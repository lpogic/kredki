#include "window.h"

namespace pastele {

void Window::planDelete(void) {
    union SDL_Event event;
    event.type = USEREVENT_DELETEWINDOW;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETEWINDOW;
    userEvent.data1 = this;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

void Window::planClose(void) {
    union SDL_Event event;
    event.type = SDL_EVENT_WINDOW_CLOSE_REQUESTED;
    SDL_WindowEvent windowEvent;
    windowEvent.type = SDL_EVENT_WINDOW_CLOSE_REQUESTED;
    windowEvent.windowID = SDL_GetWindowID(sdl_window);
    event.window = windowEvent;
    SDL_PushEvent(&event);
}

void Window::updateRequest(void) {
    union SDL_Event event;
    event.type = USEREVENT_UPDATEWINDOW;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_UPDATEWINDOW;
    userEvent.windowID = SDL_GetWindowID(sdl_window);
    userEvent.data1 = this;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

void Window::setScene(tvg::Scene* scene) {
    auto canvas = getCanvas();
    canvas->remove();
    canvas->add(scene);
    needUpdate = true;
}

void Window::sync(void) {
    auto canvas = getCanvas();

    if (needResize) {
        resize();
        needResize = false;
        needDraw = true;
    }

    if(update(canvas)) {
        needDraw = true;
    }

    if (needDraw) {
        canvas->draw();
        needDraw = false;
        needSync = true;
    }

    if(needSync) {
        syncAndUpdateSurface();
        needSync = false;
    }
}

bool Window::update(tvg::Canvas* canvas) {
    if(needUpdate) {
        canvas->update();
        return true;
    }
    return false;
}

void Window::setNeedResize() {
    needResize = true;
}

void Window::paintToUpdate(tvg::Paint* paint) {
    needUpdate = true;
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
    SDL_SetWindowBordered(sdl_window, bordered);
}

void Window::setFullscreen(bool fullscreen) {
    SDL_SetWindowFullscreen(sdl_window, fullscreen);
}

void Window::setGrab(bool grab) {
    SDL_SetWindowMouseGrab(sdl_window, grab);
}

bool Window::getGrab(void) {
    return SDL_GetWindowMouseGrab(sdl_window);
}

void Window::setMouseRelativeMode(bool relative) {
    SDL_SetWindowRelativeMouseMode(sdl_window, relative);
}

bool Window::getMouseRelativeMode(void) {
    return SDL_GetWindowRelativeMouseMode(sdl_window);
}

void Window::setMinimumSize(int w, int h) {
    SDL_SetWindowMinimumSize(sdl_window, w, h);
}

void Window::setMaximumSize(int w, int h) {
    SDL_SetWindowMaximumSize(sdl_window, w, h);
}

void Window::getMinimumSize(int*w, int* h) {
    SDL_GetWindowMinimumSize(sdl_window, w, h);
}

void Window::getMaximumSize(int*w, int* h) {
    SDL_GetWindowMaximumSize(sdl_window, w, h);
}

void Window::setOpacity(float opacity) {
    SDL_SetWindowOpacity(sdl_window, opacity);
}

float Window::getOpacity() {
    return SDL_GetWindowOpacity(sdl_window);
}

void Window::setPosition(int x, int y) {
    SDL_SetWindowPosition(sdl_window, x, y);
}

void Window::setResizable(bool resizable) {
    SDL_SetWindowResizable(sdl_window, resizable);
}

void Window::setSize(int w, int h) {
    SDL_SetWindowSize(sdl_window, w, h);
    setNeedResize();
}

void Window::setTitle(char* title) {
    SDL_SetWindowTitle(sdl_window, title);
}

const char* Window::getTitle() {
    return SDL_GetWindowTitle(sdl_window);
}

void Window::setAlwaysOnTop(bool on_top) {
    SDL_SetWindowAlwaysOnTop(sdl_window, on_top);
}

void Window::getSize(int* x, int* y) {
    SDL_GetWindowSize(sdl_window, x, y);
}

void Window::getPosition(int* x, int* y) {
    SDL_GetWindowPosition(sdl_window, x, y);
}

void Window::setTextInput(bool text_input) {
    if(text_input) {
        SDL_StartTextInput(sdl_window);
    } else {
        SDL_StopTextInput(sdl_window);
    }
}

bool Window::getTextInput() {
    return SDL_TextInputActive(sdl_window);
}

int Window::getFlags() {
    return (int) SDL_GetWindowFlags(sdl_window);
}

void Window::surfaceToPng(const char* file) {
    needDraw = true;
    sync();
    auto surface = SDL_GetWindowSurface(sdl_window);
    if (!surface) return;
    SDL_SavePNG(surface, file);
}

void Window::getDisplayBounds(SDL_Rect* rect) {
    auto display = SDL_GetDisplayForWindow(sdl_window);
    SDL_GetDisplayBounds(display, rect);
}

void Window::show(void) {
    SDL_ShowWindow(sdl_window);
    setNeedResize();
    needDraw = true;
}

void Window::hide(void) {
    SDL_HideWindow(sdl_window);
}

}