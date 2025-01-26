#include <iostream>
#include "arena.h"
using namespace std;

namespace pas {

void Arena::setEventHandler(int(*eventHandler)(int, SDL_Event*)) {
    this->eventHandler = eventHandler;
}

void Arena::insertWindow(Window* window) {
    windows.insert(window);
    SDL_ShowWindow(window->sdl_window);
}

void Arena::eraseWindow(Window* window) {
    windows.erase(window);
    SDL_HideWindow(window->sdl_window);
}

void Arena::run() {
    SDL_Event event;

    running = true;
    while (running) {
        if(SDL_WaitEvent(&event)) {
            switch (event.type) {
                case USEREVENT_UPDATEWINDOW: {
                    auto window = (Window*)event.user.data1;
                    window->step(SDL_GetTicks());
                    window->sync();
                    break;
                }
                case USEREVENT_DELETEWINDOW: {
                    auto window = (Window*)event.user.data1;
                    SDL_DestroyWindow(window->sdl_window);
                    delete(window);
                    break;
                }
                case SDL_EVENT_QUIT: {
                    if(!eventHandler(event.type, &event)) {
                        running = false;
                    }
                    break;
                }
                case SDL_EVENT_WINDOW_RESIZED:
                case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED: {
                    for(auto window : windows) {
                        if(SDL_GetWindowID(window->sdl_window) == event.window.windowID) {
                            window->setNeedResize();
                        }
                    }
                    eventHandler(event.type, &event);
                    break;
                }
                case USEREVENT_DELETEPAINT: {
                    auto paint = (tvg::Paint*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(paint)) break;
                    }
                    delete paint;
                    break;
                }
                case USEREVENT_DELETESCENE: {
                    auto scene = (tvg::Scene*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(scene)) break;
                    }
                    delete scene;
                    break;
                }
                case USEREVENT_DELETESHAPE: {
                    auto shape = (tvg::Shape*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(shape)) break;
                    }
                    delete shape;
                    break;
                }
                case USEREVENT_DELETETEXT: {
                    auto text = (tvg::Text*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(text)) break;
                    }
                    delete text;
                    break;
                }
                case USEREVENT_DELETEANIMATION: {
                    auto animation = (tvg::Animation*)event.user.data1;
                    delete animation;
                    break;
                }
                default: {
                    eventHandler(event.type, &event);
                }
            }
        } else {
            cout << SDL_GetError() << endl;
        }
    }
}

void Arena::terminate(void) {
    running = false;
}

}