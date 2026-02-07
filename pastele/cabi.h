#ifndef __CABI_H__
#define __CABI_H__

#include <stdint.h>
#include <stdbool.h>
#include "window.h"
#include "sw_window.h"
#include "gl_window.h"
#include "wg_window.h"
#include "application.h"

#ifdef _WIN32
    #define CABI __declspec(dllexport)
#else
    #define CABI __attribute__((visibility("default")))
#endif

using namespace tvg;

extern "C" {

typedef struct {
    float x, y, w, h;
} Bounds;

typedef struct {
    int x, y;
} IntPoint;

CABI int thorvg_engine_init(int engine_method, int threads);
CABI int thorvg_engine_term(int engine_method);
CABI void sdl_init(int joystick_enabled);
CABI int sdl_get_ticks();

CABI void clipboard_set_text(char* text);
CABI char* clipboard_get_text(void);
CABI void clipboard_get_mime_types(void(*consumer)(char*));

CABI uint8_t keyboard_get_key_state(int keycode);
CABI uint16_t keyboard_get_mod_state(void);

CABI uint32_t mouse_get_button_state(int index);
CABI void mouse_get_cursor_position(Point* point);
CABI void mouse_set_capture(int set);
CABI void* mouse_create_system_cursor(int cursor);
CABI void mouse_set_cursor(SDL_Cursor* cursor);

CABI uint32_t joystick_open(int index);
CABI uint8_t joystick_get_button_state(int device_id, int button_index);
CABI int16_t joystick_get_axis_value(int device_id, int axis_index);

CABI void* application_new(void);
CABI void application_delete(pastele::Application* self);
CABI uint32_t application_insert_window(pastele::Application* self, pastele::Window* window);
CABI uint32_t application_erase_window(pastele::Application* self, pastele::Window* window);
CABI void application_set_event_handler(pastele::Application* self, int(*eventHandler)(int, SDL_Event*));
CABI void application_run(pastele::Application* self);
CABI void application_exit(pastele::Application* self);

CABI void* window_new_sw(int width, int height);
CABI void* window_new_gl(int width, int height);
CABI void window_delete(pastele::Window* self);
CABI void window_close(pastele::Window* self);
CABI void window_update(pastele::Window* self);
CABI void window_show(pastele::Window* self);
CABI void window_hide(pastele::Window* self);
CABI void window_set_scene(pastele::Window* self, tvg::Scene* scene);
CABI void window_paint_to_update(pastele::Window* self, tvg::Paint* paint);
CABI void window_maximize(pastele::Window* self);
CABI void window_minimize(pastele::Window* self);
CABI void window_focus(pastele::Window* self);
CABI void window_restore(pastele::Window* self);
CABI void window_set_bordered(pastele::Window* self, int bordered);
CABI void window_set_fullscreen(pastele::Window* self, int fullscreen);
CABI void window_set_mouse_grab(pastele::Window* self, int grab);
CABI int window_get_mouse_grab(pastele::Window* self);
CABI void window_set_mouse_relative_mode(pastele::Window* self, int relative);
CABI int window_get_mouse_relative_mode(pastele::Window* self);
CABI void window_set_minimum_size(pastele::Window* self, int w, int h);
CABI void window_set_maximum_size(pastele::Window* self, int w, int h);
CABI void window_get_minimum_size(pastele::Window* self, IntPoint* point);
CABI void window_get_maximum_size(pastele::Window* self, IntPoint* point);
CABI void window_set_opacity(pastele::Window* self, float opacity);
CABI float window_get_opacity(pastele::Window* self);
CABI void window_set_position(pastele::Window* self, int x, int y);
CABI void window_set_resizable(pastele::Window* self, int resizable);
CABI void window_set_size(pastele::Window* self, int w, int h);
CABI void window_set_title(pastele::Window* self, char* title);
CABI const char* window_get_title(pastele::Window* self);
CABI void window_set_always_on_top(pastele::Window* self, int on_top);
CABI void window_get_size(pastele::Window* self, IntPoint* point);
CABI void window_get_position(pastele::Window* self, IntPoint* point);
CABI void window_set_text_input(pastele::Window* self, int input);
CABI int window_get_text_input(pastele::Window* self);
CABI int window_get_flags(pastele::Window* self);
CABI void window_surface_to_png(pastele::Window* self, const char* file);
CABI void window_get_display_bounds(pastele::Window* self, Bounds* bounds);
CABI void window_get_pixel_color(pastele::Window* self, int x, int y, IntPoint* rg, IntPoint* ba);

CABI void paint_delete(Paint* self);
CABI void paint_set_transform(Paint* self, float pivot_x, float pivot_y, float x, float y, float a, float mag_x, float fy);
CABI void paint_set_opacity(Paint* self, uint8_t opacity);
CABI void paint_get_bounds(Paint* self, Bounds* bounds);
CABI void paint_set_clip(Paint* self, Shape* clipper);
CABI void paint_set_mask(Paint* self, Paint* target, int mask);
CABI void paint_set_blend_method(Paint* self, int method);
CABI void paint_accessor_traverse(Paint* self, int(*callback)(const tvg::Paint* paint, void* data));
CABI int paint_get_type(Paint* self);

CABI void* shape_new(void);
CABI void shape_delete(Shape* self);
CABI void shape_reset(Shape* self);
CABI void shape_move_to(Shape* self, float x, float y);
CABI void shape_line_to(Shape* self, float x, float y);
CABI void shape_cubic_to(Shape* self, float cx1, float cy1, float cx2, float cy2, float x, float y);
CABI void shape_close(Shape* self);
CABI void shape_append_rect(Shape* self, float x, float y, float w, float h);
CABI void shape_append_circle(Shape* self, float cx, float cy, float rx, float ry);
CABI void shape_append_round_rect(Shape* self, float x, float y, float w, float h, float corner_ss, float corner_se, float corner_es, float corner_ee);
CABI void shape_set_stroke_width(Shape* self, float width);
CABI void shape_set_stroke_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
CABI void shape_set_stroke_linear_gradient(Shape* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);
CABI void shape_set_stroke_radial_gradient(Shape* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);
CABI void shape_set_stroke_dash(Shape* self, const float* dashPattern, uint32_t cnt, float offset);
CABI void shape_set_stroke_cap(Shape* self, int cap);
CABI void shape_set_stroke_join(Shape* self, int join);
CABI void shape_set_stroke_miterlimit(Shape* self, float miterlimit);
CABI void shape_set_stroke_trim(Shape* self, float begin, float end, int simultaneous);
CABI void shape_set_fill_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
CABI void shape_set_fill_rule(Shape* self, int rule);
CABI void shape_set_paint_order(Shape* self, int strokeFirst);
CABI void shape_set_fill(Shape* self, Fill* fill);
CABI void shape_set_fill_linear_gradient(Shape* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);
CABI void shape_set_fill_radial_gradient(Shape* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);

CABI Picture* picture_new(void);
CABI int picture_load(Picture* self, const char* path);
// CABI int picture_load_raw(Picture* self, uint32_t *data, uint32_t w, uint32_t h, bool premultiplied, bool copy);
// CABI int picture_load_data(Picture* self, const char *data, uint32_t size, const char *mimetype, const char* rpath, bool copy);
CABI void picture_set_size(Picture* self, float w, float h);
CABI void picture_get_size(Picture* self, Point* size);
CABI void* picture_accessor_get(Picture* self, const char* id);

CABI void* scene_new(void);
CABI void scene_delete(Scene* self);
CABI void scene_add(Scene* self, Paint* paint, Paint* at);
CABI void scene_remove(Scene* self, Paint* paint);
CABI void scene_clear_effects(Scene* self);
CABI void scene_add_gaussian_blur(Scene* self, double sigma, int direction, int border, int quality);
CABI void scene_add_drop_shadow(Scene* self, int r, int g, int b, int a, double angle, double distance, double blurSigma, int quality);
CABI void scene_add_fill(Scene* self, int r, int g, int b, int a);
CABI void scene_add_tint(Scene* self, int br, int bg, int bb, int wr, int wg, int wb, double intensity);
CABI void scene_add_tritone(Scene* self, int sr, int sg, int sb, int mr, int mg, int mb, int hr, int hg, int hb, int blend);

CABI void* text_new(void);
CABI void text_delete(Text* self);
CABI void text_set_font(Text* self, const char* fontName);
CABI void text_set_size(Text* self, float size);
CABI void text_set_text(Text* self, const char* text);
CABI void text_set_fill_color(Text* self, uint8_t r, uint8_t g, uint8_t b);
CABI void text_set_fill_linear_gradient(Text* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);
CABI void text_set_fill_radial_gradient(Text* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread);
CABI void text_set_outline(Text* self, float width, uint8_t r, uint8_t g, uint8_t b);
CABI float text_get_text_width(Text* self, const char* text, int indexRequest);
CABI int text_nearest_character_index(Text* self, const char* text, float widthRequest);

CABI int font_load(const char* path);
CABI int font_unload(const char* path);

CABI Animation* animation_new(void);
CABI void animation_set_frame(Animation* self, float no);
CABI Paint* animation_get_picture(Animation* self);
CABI float animation_get_total_frames(Animation* self);
CABI float animation_get_duration(Animation* self);
CABI void animation_set_segment(Animation* self, float begin, float end);
CABI void animation_delete(Animation* self);

// CABI Tvg_Animation* tvg_lottie_animation_new(void);
// CABI int tvg_lottie_animation_override(Animation* self, const char* slot);
// CABI int tvg_lottie_animation_set_marker(Animation* self, const char* marker);
// CABI int tvg_lottie_animation_get_markers_cnt(Animation* self, uint32_t* cnt);
// CABI int tvg_lottie_animation_get_marker(Animation* self, uint32_t ifx, const char** name);

}

#endif //_CABI_H_
