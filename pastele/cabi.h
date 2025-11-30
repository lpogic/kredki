#ifndef __CABI_H__
#define __CABI_H__

#include <stdint.h>
#include <stdbool.h>
#include "window.h"
#include "sw_window.h"
#include "gl_window.h"
#include "wg_window.h"
#include "arena.h"

#define CABI __declspec(dllexport)

using namespace tvg;

#ifdef __cplusplus
extern "C" {
#endif

#define TVG_ENGINE_SW (1 << 1)    ///< CPU rasterizer.
#define TVG_ENGINE_GL (1 << 2)    ///< OpenGL rasterizer.

#define TVG_RESULT_SUCCESS 0                ///< The value returned in case of a correct request execution.
#define TVG_RESULT_INVALID_ARGUMENT 1       ///< The value returned in the event of a problem with the arguments given to the API - e.g. empty paths or null pointers.
#define TVG_RESULT_INSUFFICIENT_CONDITION 2 ///< The value returned in case the request cannot be processed - e.g. asking for properties of an object, which does not exist.
#define TVG_RESULT_FAILED_ALLOCATION 3      ///< The value returned in case of unsuccessful memory allocation.
#define TVG_RESULT_MEMORY_CORRUPTION 4      ///< The value returned in the event of bad memory handling - e.g. failing in pointer releasing or casting
#define TVG_RESULT_NOT_SUPPORTED 5          ///< The value returned in case of choosing unsupported engine features(options).
#define TVG_RESULT_UNKNOWN 6                ///< The value returned in all other cases.

#define TVG_IDENTIFIER_UNDEF 0   ///< Undefined type.
#define TVG_IDENTIFIER_SHAPE 1       ///< A shape type paint.
#define TVG_IDENTIFIER_SCENE 2      ///< A scene type paint.
#define TVG_IDENTIFIER_PICTURE 3     ///< A picture type paint.
#define TVG_IDENTIFIER_LINEAR_GRAD 4 ///< A linear gradient type.
#define TVG_IDENTIFIER_RADIAL_GRAD 5 ///< A radial gradient type.
#define TVG_IDENTIFIER_TEXT 6         ///< A text type paint.

#define TVG_PATH_COMMAND_CLOSE 0 ///< Ends the current sub-path and connects it with its initial point - corresponds to Z command in the svg path commands.
#define TVG_PATH_COMMAND_MOVE_TO 1   ///< Sets a new initial point of the sub-path and a new current point - corresponds to M command in the svg path commands.
#define TVG_PATH_COMMAND_LINE_TO 2   ///< Draws a line from the current point to the given point and sets a new value of the current point - corresponds to L command in the svg path commands.
#define TVG_PATH_COMMAND_CUBIC_TO 3   ///< Draws a cubic Bezier curve from the current point to the given point using two given control points and sets a new value of the current point - corresponds to C command in the svg path commands.

#define TVG_STROKE_FILL_PAD 0 ///< The remaining area is filled with the closest stop color.
#define TVG_STROKE_FILL_REFLECT 1 ///< The gradient pattern is reflected outside the gradient area until the expected region is filled.
#define TVG_STROKE_FILL_REPEAT 2   ///< The gradient pattern is repeated continuously beyond the gradient area until the expected region is filled.

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

#define TVG_MEMPOOL_POLICY_DEFAULT 0 ///< Default behavior that ThorVG is designed to.
#define TVG_MEMPOOL_POLICY_SHAREABLE 1   ///< Memory Pool is shared among canvases.
#define TVG_MEMPOOL_POLICY_INDIVIDUAL 2   ///< Allocate designated memory pool that is used only by the current canvas instance.

#define TVG_COLORSPACE_ABGR8888 0 ///< The channels are joined in the order: alpha, blue, green, red. Colors are alpha-premultiplied. (a << 24 | b << 16 | g << 8 | r)
#define TVG_COLORSPACE_ARGB8888 1     ///< The channels are joined in the order: alpha, red, green, blue. Colors are alpha-premultiplied. (a << 24 | r << 16 | g << 8 | b)
#define TVG_COLORSPACE_ABGR8888S 2    ///< The channels are joined in the order: alpha, blue, green, red. Colors are un-alpha-premultiplied. @since 0.13
#define TVG_COLORSPACE_ARGB8888S 3     ///< The channels are joined in the order: alpha, red, green, blue. Colors are un-alpha-premultiplied. @since 0.13

CABI void clipboard_set_text(char* text);
CABI char* clipboard_get_text(void);

CABI uint8_t keyboard_get_key_state(int keycode);
CABI uint16_t keyboard_get_shift_state(void);
CABI uint16_t keyboard_get_ctrl_state(void);
CABI uint16_t keyboard_get_alt_state(void);
CABI uint16_t keyboard_get_num_state(void);
CABI uint16_t keyboard_get_caps_state(void);
CABI uint16_t keyboard_get_scroll_state(void);

CABI uint32_t mouse_get_button_state(int index);
CABI void mouse_get_cursor_position(Point* point);
CABI void mouse_set_relative_mode(int set);
CABI void mouse_set_capture(int set);

CABI uint32_t joystick_open(int index);
CABI uint8_t joystick_get_button_state(int device_id, int button_index);
CABI int16_t joystick_get_axis_value(int device_id, int axis_index);


CABI void* arena_new(void);
CABI void arena_delete(pas::Arena* self);
CABI uint32_t arena_insert_window(pas::Arena* self, pas::Window* window);
CABI uint32_t arena_erase_window(pas::Arena* self, pas::Window* window);
CABI void arena_set_event_handler(pas::Arena* self, int(*eventHandler)(int, SDL_Event*));
CABI void arena_run(pas::Arena* self);
CABI void arena_terminate(pas::Arena* self);

CABI void* window_new(int width, int height);
CABI void window_delete(pas::Window* self);
CABI void window_update(pas::Window* self);
CABI void window_set_scene(pas::Window* self, tvg::Scene* scene);
CABI void window_set_step_handler(pas::Window* self, void(*stepHandler)(int));
CABI void window_paint_to_update(pas::Window* self, tvg::Paint* paint);
CABI void window_maximize(pas::Window* self);
CABI void window_minimize(pas::Window* self);
CABI void window_focus(pas::Window* self);
CABI void window_restore(pas::Window* self);
CABI void window_set_bordered(pas::Window* self, int bordered);
CABI void window_set_fullscreen(pas::Window* self, int fullscreen);
CABI void window_set_mouse_grab(pas::Window* self, int grab);
CABI int window_get_mouse_grab(pas::Window* self);
CABI void window_set_maximum_size(pas::Window* self, int w, int h);
CABI void window_set_minimum_size(pas::Window* self, int w, int h);
CABI void window_get_minimum_size(pas::Window* self, IntPoint* point);
CABI void window_set_opacity(pas::Window* self, float opacity);
CABI void window_set_position(pas::Window* self, int x, int y);
CABI void window_set_resizable(pas::Window* self, int resizable);
CABI void window_set_size(pas::Window* self, int w, int h);
CABI void window_set_title(pas::Window* self, char* title);
CABI void window_set_always_on_top(pas::Window* self, int on_top);
CABI void window_get_size(pas::Window* self, IntPoint* point);
CABI void window_get_position(pas::Window* self, IntPoint* point);
CABI void window_set_text_input(pas::Window* self, int input);
CABI int window_get_text_input(pas::Window* self);
CABI int window_get_flags(pas::Window* self);

CABI void paint_delete(Paint* self);
CABI void paint_set_transform(Paint* self, float pivot_x, float pivot_y, float x, float y, float a, float magx, float fy);
CABI void paint_set_opacity(Paint* self, uint8_t opacity);
CABI void paint_get_bounds(Paint* self, Bounds* bounds);
CABI void paint_set_clip(Paint* self, Shape* clipper);
CABI void paint_set_mask(Paint* self, Paint* target, int mask);
CABI void paint_set_blend_method(Paint* self, int method);

CABI void* shape_new(void);
CABI void shape_delete(Shape* self);
CABI void shape_reset(Shape* self);
CABI void shape_move_to(Shape* self, float x, float y);
CABI void shape_line_to(Shape* self, float x, float y);
CABI void shape_cubic_to(Shape* self, float cx1, float cy1, float cx2, float cy2, float x, float y);
CABI void shape_close(Shape* self);
CABI void shape_append_rect(Shape* self, float x, float y, float w, float h);
CABI void shape_append_circle(Shape* self, float cx, float cy, float rx, float ry);
CABI void shape_append_round_rect(Shape* self, float x, float y, float w, float h, float crtt, float crth, float crht, float crhh);
CABI void shape_set_stroke_width(Shape* self, float width);
CABI void shape_set_stroke_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
// CABI int tvg_shape_set_stroke_linear_gradient(Shape* self, Tvg_Gradient* grad);
// CABI int tvg_shape_set_stroke_radial_gradient(Shape* self, Tvg_Gradient* grad);
// CABI int tvg_shape_get_stroke_gradient(const Shape* self, Tvg_Gradient** grad);
CABI void shape_set_stroke_dash(Shape* self, const float* dashPattern, uint32_t cnt, float offset);
CABI void shape_set_stroke_cap(Shape* self, int cap);
CABI void shape_set_stroke_join(Shape* self, int join);
CABI void shape_set_stroke_miterlimit(Shape* self, float miterlimit);
CABI void shape_set_stroke_trim(Shape* self, float begin, float end, int simultaneous);
CABI void shape_set_fill_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
CABI void shape_set_fill_rule(Shape* self, int rule);
CABI void shape_set_paint_order(Shape* self, int strokeFirst);
// CABI int tvg_shape_set_linear_gradient(Shape* self, Tvg_Gradient* grad);
// CABI int tvg_shape_set_radial_gradient(Shape* self, Tvg_Gradient* grad);
// CABI int tvg_shape_get_gradient(const Shape* self, Tvg_Gradient** grad);
// CABI Tvg_Gradient* tvg_linear_gradient_new(void);
// CABI Tvg_Gradient* tvg_radial_gradient_new(void);
// CABI int tvg_linear_gradient_set(Tvg_Gradient* grad, float x1, float y1, float x2, float y2);
// CABI int tvg_linear_gradient_get(Tvg_Gradient* grad, float* x1, float* y1, float* x2, float* y2);
// CABI int tvg_radial_gradient_set(Tvg_Gradient* grad, float cx, float cy, float radius);
// CABI int tvg_radial_gradient_get(Tvg_Gradient* grad, float* cx, float* cy, float* radius);
// CABI int tvg_gradient_set_color_stops(Tvg_Gradient* grad, const Tvg_Color_Stop* color_stop, uint32_t cnt);
// CABI int tvg_gradient_get_color_stops(const Tvg_Gradient* grad, const Tvg_Color_Stop** color_stop, uint32_t* cnt);
// CABI int tvg_gradient_set_spread(Tvg_Gradient* grad, const Tvg_Stroke_Fill spread);
// CABI int tvg_gradient_get_spread(const Tvg_Gradient* grad, Tvg_Stroke_Fill* spread);
// CABI int tvg_gradient_set_transform(Tvg_Gradient* grad, const Tvg_Matrix* m);
// CABI int tvg_gradient_get_transform(const Tvg_Gradient* grad, Tvg_Matrix* m);
// CABI int tvg_gradient_get_identifier(const Tvg_Gradient* grad, Tvg_Identifier* identifier);
// CABI Tvg_Gradient* tvg_gradient_duplicate(Tvg_Gradient* grad);
// CABI int tvg_gradient_del(Tvg_Gradient* grad);
CABI Picture* picture_new(void);
CABI int picture_load(Picture* self, const char* path);
// CABI int picture_load_raw(Picture* self, uint32_t *data, uint32_t w, uint32_t h, bool premultiplied, bool copy);
// CABI int picture_load_data(Picture* self, const char *data, uint32_t size, const char *mimetype, const char* rpath, bool copy);
CABI void picture_set_size(Picture* self, float w, float h);
CABI void picture_get_size(Picture* self, Point* size);
CABI void* scene_new(void);
CABI void scene_delete(Scene* self);
CABI void scene_push(Scene* self, Paint* paint, Paint* at);
CABI void scene_remove(Scene* self, Paint* paint);
CABI void* text_new(void);
CABI void text_delete(Text* self);
CABI void text_set_font(Text* self, const char* fontName);
CABI void text_set_size(Text* self, float size);
CABI void text_set_text(Text* self, const char* text);
CABI float text_get_text_width(Text* self, const char* text, int indexRequest);
CABI int text_nearest_character_index(Text* self, const char* text, float widthRequest);
CABI void text_set_fill_color(Text* self, uint8_t r, uint8_t g, uint8_t b);
// CABI int tvg_text_set_linear_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient);
// CABI int tvg_text_set_radial_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient);
CABI int font_load(const char* path);
CABI int font_unload(const char* path);
// CABI Tvg_Saver* tvg_saver_new(void);
// CABI int tvg_saver_save(Tvg_Saver* saver, Tvg_Paint* paint, const char* path, uint32_t quality);
// CABI int tvg_saver_sync(Tvg_Saver* saver);
// CABI int tvg_saver_del(Tvg_Saver* saver);
CABI Animation* animation_new(void);
CABI void animation_set_frame(Animation* self, float no);
CABI Paint* animation_get_picture(Animation* self);
// CABI int tvg_animation_get_frame(Animation* self, float* no);
CABI float animation_get_total_frame(Animation* self);
CABI float animation_get_duration(Animation* self);
CABI void animation_set_segment(Animation* self, float begin, float end);
// CABI int tvg_animation_get_segment(Animation* self, float* begin, float* end);
CABI void animation_delete(Animation* self);
// CABI Tvg_Animation* tvg_lottie_animation_new(void);
// CABI int tvg_lottie_animation_override(Animation* self, const char* slot);
// CABI int tvg_lottie_animation_set_marker(Animation* self, const char* marker);
// CABI int tvg_lottie_animation_get_markers_cnt(Animation* self, uint32_t* cnt);
// CABI int tvg_lottie_animation_get_marker(Animation* self, uint32_t ifx, const char** name);

#ifdef __cplusplus
}
#endif

#endif //_THORVG_CABI_H_
