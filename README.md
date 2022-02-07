# proinit
---
**simple project initialization script that automates the process of setting up a new project.**

Currently suports c c++ Java and Scala projects

### Project:

A projects created by proinit looks like the folowing:
```shell
test-project
├── .git
│   └─── ...
├── .gitignore
├── Makefile
├── README.md
└── src
    └── main.c
```
to generate this project the folowing command was used
```shell
$ proinit test-project --language c --template MY_TEMPLATE --git
```
---
#### Creating templates
more templates for the already supported languages can be added in their respective  `~/.proinit/<language>/templates` folder and will then automaticaly be available to use with the proinit script

---

#### Limitations

 - **package** generated Java and Scala package names are currently the project name in all lower case
