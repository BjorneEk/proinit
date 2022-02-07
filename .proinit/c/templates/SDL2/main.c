
////////////////////////////////////////////////////////////////////////////
///        @author Gustaf Franzén :: https://github.com/BjorneEk;        ///
////////////////////////////////////////////////////////////////////////////


#include"/Library/Frameworks/SDL2.framework/Headers/SDL.h"   /* All SDL App's need this */

#define __timespec_defined   1
#define __timeval_defined    1
#define __itimerspec_defined 1

#include <stdio.h>
#include <stdlib.h>

#define WIDTH  2000
#define HEIGHT 1200

SDL_Window *  screen = NULL;
SDL_Renderer* renderer;
SDL_Event     event;


int errorCount = 0;

void log_error(char* msg) {
	printf("%s\n", msg);
	errorCount++;
}

void show() {
	SDL_RenderPresent(renderer);
}

void finnish() {
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(screen);
	SDL_Quit();
	exit(0);
}

void init_setup() {
	SDL_Init(SDL_INIT_EVERYTHING);
	SDL_CreateWindowAndRenderer(WIDTH, HEIGHT, SDL_WINDOW_SHOWN, &screen, &renderer);
	if (!screen) {
		log_error("init_setup failed to create window");
	fill_rect( renderer, 0, 0, WIDTH, HEIGHT, bg_color );
	set_caption("new project", screen);
	show();
}

void event_loop() {
	int gameRunning = 1;
	while (gameRunning) {
		while ( SDL_PollEvent( &event ) ) {
			switch ( event.type ) {
				case SDL_MOUSEBUTTONDOWN:
					switch (event.button.button) {
						case SDL_BUTTON_LEFT:  break;
						case SDL_BUTTON_RIGHT: break;
						default:               break;
					}
					break;
				case SDL_MOUSEBUTTONUP:
					switch (event.button.button) {
						case SDL_BUTTON_LEFT:  break;
						case SDL_BUTTON_RIGHT: break;
						default:               break;
					}
					break;
				case SDL_MOUSEMOTION:
						/* event.motion.x event.motion.y */
					break;
				case SDL_QUIT:
					gameRunning = 0;
					break;
				case SDL_KEYDOWN: break;
				case SDL_KEYUP:   break;
			}
		}
	}
}

int main(int argc, char * args[]) {
	init_setup();
	event_loop();
	finnish();
	return 0;
}
