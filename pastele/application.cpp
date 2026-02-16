#include <iostream>
#include "application.h"
using namespace std;

namespace pastele {

void Application::setEventHandler(int(*eventHandler)(int, SDL_Event*)) {
    this->eventHandler = eventHandler;
}

void Application::insertWindow(Window* window) {
    windows.insert(window);
}

void Application::eraseWindow(Window* window) {
    windows.erase(window);
}

bool Application::watcher(SDL_Event* event){
    if(event->type == SDL_EVENT_WINDOW_EXPOSED){
        if(event->window.data1 == 1) {
            eventHandler(event->type, event);
            return false;
        }       
    }
    return true;
}

void Application::run() {
    SDL_Event event;

    SDL_AddEventWatch([](void *userdata, SDL_Event* event) -> bool {
        return ((Application*)userdata)->watcher(event);
    }, this);

    running = true;
    while (running) {
        if(SDL_WaitEvent(&event)) {
            switch (event.type) {
                case USEREVENT_UPDATEWINDOW: {
                    auto window = (Window*)event.user.data1;
                    event.user.timestamp = SDL_GetTicksNS();
                    eventHandler(event.type, &event);
                    window->sync();
                    event.type = USEREVENT_UPDATECOMPLETEWINDOW;
                    event.user.timestamp = SDL_GetTicksNS();
                    eventHandler(event.type, &event);
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
                    tvg::Paint::rel(paint);
                    break;
                }
                case USEREVENT_DELETESCENE: {
                    auto scene = (tvg::Scene*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(scene)) break;
                    }
                    tvg::Paint::rel(scene);
                    break;
                }
                case USEREVENT_DELETESHAPE: {
                    auto shape = (tvg::Shape*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(shape)) break;
                    }
                    tvg::Paint::rel(shape);
                    break;
                }
                case USEREVENT_DELETETEXT: {
                    auto text = (tvg::Text*)event.user.data1;
                    for(auto window : windows) {
                        if(window->paintDelete(text)) break;
                    }
                    tvg::Paint::rel(text);
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

void Application::exit(void) {
    running = false;
}

}