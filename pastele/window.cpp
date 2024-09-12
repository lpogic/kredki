#include "window.h"

namespace pas {

void Window::planDelete(void) {
    union SDL_Event event;
    event.type = SDL_USEREVENT_DELETEWINDOW;
    SDL_UserEvent userEvent;
    userEvent.type = SDL_USEREVENT_DELETEWINDOW;
    userEvent.data1 = this;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

void Window::planUpdate(void) {
    union SDL_Event event;
    event.type = SDL_USEREVENT_UPDATEWINDOW;
    SDL_UserEvent userEvent;
    userEvent.type = SDL_USEREVENT_UPDATEWINDOW;
    userEvent.data1 = this;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

void Window::setScene(tvg::Scene* scene) {
    auto canvas = getCanvas();
    canvas->paints().clear();
    canvas->push(unique_ptr<tvg::Scene>(scene));
    toUpdate.insert(nullptr);
}

void Window::setStepHandler(void(*stepHandler)(int)) {
    this->stepHandler = stepHandler;
}

void Window::step(uint32_t ms) {
    auto canvas = getCanvas();

    if (needResize) {
        resize();
        needResize = false;
        needDraw = true;
    }

    if(stepHandler) {
        stepHandler(ms);
    }

    if(update(canvas)) {
        needDraw = true;
    }

    if (needDraw) {
        canvas->draw();
        needDraw = false;
        needSync = true;
    }
}

void Window::sync(void) {
    if(needSync) {
        syncAndUpdateSurface();
        needSync = false;
    }
}

bool Window::update(tvg::Canvas* canvas) {
    if(toUpdate.empty()) {
        return false;
    } else {
        // canvas->update(nullptr);
        for(auto paint : toUpdate) {
            canvas->update(paint);
        }
        toUpdate.clear();
        return true;
    }
}

bool Window::paintDelete(tvg::Paint* paint) {
    return toUpdate.erase(paint) > 0;
}

void Window::setNeedResize() {
    needResize = true;
}

void Window::paintToUpdate(tvg::Paint* paint) {
    toUpdate.insert(paint);
}

void Window::maximize(void) {
    SDL_MaximizeWindow(sdl_window);
}

void Window::minimize(void) {
    SDL_MinimizeWindow(sdl_window);
}

void Window::focus() {
    SDL_RaiseWindow(sdl_window);
}

void Window::restore(void) {
    SDL_RestoreWindow(sdl_window);
}

void Window::setBordered(bool bordered) {
    SDL_SetWindowBordered(sdl_window, (SDL_bool)bordered);
}

void Window::setFullscreen(int fullscreenMethod) {
    SDL_SetWindowFullscreen(sdl_window, fullscreenMethod);
}

void Window::setGrab(bool grab) {
    SDL_SetWindowGrab(sdl_window, (SDL_bool)grab);
}

void Window::setMaximumSize(int w, int h) {
    SDL_SetWindowMaximumSize(sdl_window, w, h);
}

void Window::setMinimumSize(int w, int h) {
    SDL_SetWindowMinimumSize(sdl_window, w, h);
}

void Window::setOpacity(float opacity) {
    SDL_SetWindowOpacity(sdl_window, opacity);
}

void Window::setPosition(int x, int y) {
    SDL_SetWindowPosition(sdl_window, x, y);
}

void Window::setResizable(bool resizable) {
    SDL_SetWindowResizable(sdl_window, (SDL_bool)resizable);
}

void Window::setSize(int w, int h) {
    SDL_SetWindowSize(sdl_window, w, h);
}

void Window::setTitle(char* title) {
    SDL_SetWindowTitle(sdl_window, title);
}

void Window::setAlwaysOnTop(bool on_top) {
    SDL_SetWindowAlwaysOnTop(sdl_window, (SDL_bool)on_top);
}

void Window::getSize(int* x, int* y) {
    SDL_GetWindowSize(sdl_window, x, y);
}

}