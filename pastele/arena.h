#ifndef __PASTEL_H__
#define __PASTEL_H__

#include <set>
#include <SDL.h>
#include <SDL_syswm.h>
#include "window.h"

#define SDL_USEREVENT_DELETEWINDOW (SDL_USEREVENT + 0)
#define SDL_USEREVENT_UPDATEWINDOW (SDL_USEREVENT + 1)

namespace pas {

class Arena
{
    protected:

    int(*eventHandler)(int, SDL_Event*) = nullptr;
    set<Window*> windows;
    bool running = false;

    public:

    void setEventHandler(int(*eventHandler)(int, SDL_Event*));
    void insertWindow(Window* window);
    void eraseWindow(Window* window);
    void run();
    void terminate(void);
};

}

#endif // __PASTEL_H__