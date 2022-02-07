#!/bin/bash

########################################################################
##       @author Gustaf Franzén :: https://github.com/BjorneEk;       ##
##                                                                    ##
##  a script for initializing a project folder for various languages  ##
########################################################################

##
# $1 : the name of the project
# $2 : first argument
# $3 : second argument, or argument to previous
# $4 : third argument, or argument to previous
##

YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
LANGUAGES='c scala java'

NAME='new-project'
LANG='none'
GIT='dissabled'
TEMPLATE='main'
MAKEFILE='dissabled'



##
# arg 1: error massage
##
function error {
	echo -e  $1 >> /dev/stderr
	exit
}


function list_templates {

	local template_paths=( ~/.proinit/$1/templates/* )
	local lang=$(echo "$1" |  tr '[:lower:]' '[:upper:]' )
	printf "%s:\n" $lang
	local i=0
	for tmplt in "${template_paths[@]}"; do

		if [[ $i -eq 4 ]]; then
			printf " %s\n" ${tmplt##*/}
			i=0
		else
			if [[ $i -eq 0 ]]; then
				printf "\t%s" ${tmplt##*/}
			else
				printf " %s" ${tmplt##*/}
			fi
			i=${i+1}
		fi
	done
	echo ""
}
##
# arg 1: project name
# arg 2: language
# arg 3: git options
# arg 4: makefile settings  /Users/gustaffranzen/.proinit/java/templates  ~/.proinit/java/templates
# arg 5: template options
##
function create_project {
	local tmplt_dir=~/.proinit/$2
	local template="$tmplt_dir/templates/main"
	local package=$(echo "$1" |  tr '[:upper:]' '[:lower:]' )

	mkdir $1     # create project folder
	mkdir $1/src # create source code folder

	##
	#  initialize project from template
	##
	if [[ $5 != "main" ]]; then
		local template_paths=( ~/.proinit/$2/templates/* )
		for tmplt in "${template_paths[@]}"; do
			if [[ ${tmplt##*/} == $5 ]]; then
				template=$tmplt
			fi
		done
		if [[ ${template##*/} != $5 ]]; then
			error "${RED}error:${NC} $5 is not a valid template try: $0 -lt <language> to list available templates"
			exit 1
		fi
	fi
	if [[ $2 != "none" ]]; then
		cp -r $template/ $1/src/
	fi

	##
	#  initialize project with makefile
	##
	if [[ $4 == "enabled" ]]; then

		cp $tmplt_dir/Makefile $1/
		mv $1/Makefile $1/tmp

		# add correct names to makefile
		case $2 in
			c)
				echo "TARGET = $1" > $1/Makefile
				;;
			java|scala)
				echo "PACKAGE = $package" > $1/Makefile
				;;
		esac

		# move the data into the makefile from temporary file and remove it
		cat $1/tmp >> $1/Makefile
		rm $1/tmp
	fi

	#  add package tags to all source files if it is a scala or java project
	if [[ $2 == "java" || $2 == "scala" ]]; then
		#create temporary directory for source files
		mkdir $1/tmpsrc
		cp -r $1/src/ $1/tmpsrc/

		local source_files=( $1/src/* )

		for file in "${source_files[@]}"; do

			# overwrite original source file pith package tag
			echo "package $package" > $file

			# append the source code to the file with the package tag
			cat $1/tmpsrc/${file##*/} >> $file
		done

		#remove temporary source dir
		rm -r $1/tmpsrc
	fi

	##
	#   initialize git repository and git files
	##
	if [ $3 != "dissabled" ]; then
		case $3 in
			noig)
				echo "# $1" > $1/README.md
				echo "---" >> $1/README.md
				;;
			norm)
				cp $tmplt_dir/.gitignore $1
				;;
			enabled)
				echo "# $1\n---" > $1/README.md
				echo "---" >> $1/README.md
				cp $tmplt_dir/.gitignore $1
				;;
		esac
		git init $1
	fi
}





if [ "$#" -lt 1 ]; then
	error "${RED}usage:${NC} $0 <project-name>"
fi
if [ "$#" -gt 8 ]; then
	error "$0 : ${RED}error${NC} try $0 --help"
fi

for arg in "$@"; do
	case $arg in
		-lt|--list-templates)
			if [ "$#" -gt 2 ]; then
				error "$0 : ${RED}error:${NC} try $0 --list-templates or --help"
				exit 1
			fi
			if [ "$#" -eq 2 ]; then
				case $2 in
					c|C)
						list_templates "c"
						exit 0
						;;
					java|Java)
						list_templates "java"
						exit 0
						;;
					scala|Scala)
						list_templates "scala"
						exit 0
						;;
					*)
						error "${RED}error:${NC} $2 is not a valid language try: $LANGUAGES"
						exit 1
				esac
			else
				list_templates "c"
				list_templates "java"
				list_templates "scala"
				exit 0
			fi
			;;
		-h|--help)
			echo "proinit project initializer"
			echo ""
			echo "Usage: $0 <project-name> -arg <arg>"
			echo "Usage: $0 --list-templates <language> (argument <language> is optional)"
			echo -e "\t[${YELLOW}-h${NC}]             | [${YELLOW}--help${NC}]                       usage help"
			echo -e "\t[${YELLOW}-l${NC}]  <language> | [${YELLOW}--language${NC}]       <language>  specified a language, available languages are currently (c, scala, java)"
			echo -e "\t[${YELLOW}-g${NC}]  <X>        | [${YELLOW}--git${NC}]            <X>         whether to initialize a git repository, optional arguments are (noig|nogitignore, norm|noreadme, bare)"
			echo -e "\t[${YELLOW}-t${NC}]  <template> | [${YELLOW}--template${NC}]       <template>  initialize project with a template specified in the languages"
			echo -e "\t                                                  templates folder in the [\033[1;33m~/.proinit\033[0m] folder"
			echo -e "\t[${YELLOW}-lt${NC}] <language> | [${YELLOW}--list-templates${NC}] <language>  list available templates for the specified language"
			echo -e "\t[${YELLOW}-nm${NC}]            | [${YELLOW}--nomakefile${NC}]                 initialize without a makefile"
			exit 0
			;;
	esac
done

NAME=$1
shift

while [[ $# -gt 0 ]]; do
	case $1 in
		-l|--language) # set language
			if [ "$#" -lt 2 ]; then
				error "${RED}error:${NC} $0 $1, <language> expected"
				exit 1
			fi
			case $2 in
				c|C)
					LANG='c'
					MAKEFILE='enabled'
					;;
				scala|Scala)
					LANG='scala'
					MAKEFILE='enabled'
					;;
				java|Java)
					LANG='java'
					MAKEFILE='enabled'
					;;
				*)
					error "${RED}error:${NC} $3 is not a valid language try: $LANGUAGES"
					exit 1
					;;
			esac
			shift
			shift
			;;
		-g|--git)
			if [ "$#" -lt 2 ]; then
				GIT='enabled'
				shift
			else
				case $2 in
					noig|nogitignore)
						GIT='noig'
						shift
						;;
					norm|noreadme)
						GIT='norm'
						shift
						;;
					bare)
						GIT='bare'
						shift
						;;
					-*)
						GIT='enabled'
						;;
					*)
						error "${RED}error:${NC} -git ${i+1} is not a valid argument, try: $0 help"
						exit 1
						;;
				esac
				shift
			fi
			;;
		-t|--template)
			if [ "$#" -lt 2 ]; then
				error "${RED}error:${NC} $0 $1, <template> expected"
				exit 1
			else
				TEMPLATE=$2
				shift
				shift
			fi
			;;
		-nm|--nomakefile)
			MAKEFILE='disabled'
			shift
			;;
		*)
			error "${RED}error:${NC} $1 is not a valid argument, try: $0 help"
			exit 1
			;;
	esac
done

create_project "$NAME" "$LANG" "$GIT" "$MAKEFILE" "$TEMPLATE"
