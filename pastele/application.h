#ifndef __PASTEL_H__
#define __PASTEL_H__

#include <set>
#include <SDL.h>
#include <thorvg.h>
#include "window.h"

#define USEREVENT_DELETEWINDOW (SDL_EVENT_USER + 0)
#define USEREVENT_UPDATEWINDOW (SDL_EVENT_USER + 1)
#define USEREVENT_DELETEPAINT (SDL_EVENT_USER + 2)
#define USEREVENT_DELETESCENE (SDL_EVENT_USER + 3)
#define USEREVENT_DELETESHAPE (SDL_EVENT_USER + 4)
#define USEREVENT_DELETETEXT (SDL_EVENT_USER + 5)
#define USEREVENT_DELETEANIMATION (SDL_EVENT_USER + 6)
#define USEREVENT_CLOSEWINDOW (SDL_EVENT_USER + 7)
#define USEREVENT_UPDATECOMPLETEWINDOW (SDL_EVENT_USER + 8)
#define USEREVENT_S_COUNT 9

namespace pastele {

class Application
{
    protected:

    int(*eventHandler)(int, SDL_Event*) = nullptr;
    set<Window*> windows;
    bool running = false;

    public:

    void setEventHandler(int(*eventHandler)(int, SDL_Event*));
    bool watcher(SDL_Event* event);
    void insertWindow(Window* window);
    void eraseWindow(Window* window);
    void run();
    void exit(void);
};

}

#endif // __PASTEL_H__