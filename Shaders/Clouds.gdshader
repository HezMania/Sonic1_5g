shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

// Uniformy dla zmiennych konfigurowalnych
uniform vec4 cloud_color = vec4(1.0, 1.0, 1.0, 1.0); // Kolor chmur (w tym przezroczystość)
uniform float cloud_opacity : hint_range(0.0, 1.0) = 0.1; // Przezroczystość chmur

// Funkcja do interpolacji (fade) używana w szumie Perlin'a
float fade(float t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

// Funkcja do generowania gradientu
float grad(int hash, float x, float y) {
    int h = hash & 7;  // maska hash
    float u = h < 4 ? x : y;
    float v = h < 4 ? y : x;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
}

// Funkcja do generowania prostego szumu Perlin'a
float perlin_noise(vec2 coord) {
    vec2 p = floor(coord);
    vec2 f = fract(coord);
    f = f * f * (3.0 - 2.0 * f);

    float n = p.x + p.y * 57.0;
    float res = mix(
        mix(grad(int(n + 0.0), f.x, f.y),
            grad(int(n + 1.0), f.x - 1.0, f.y), fade(f.x)),
        mix(grad(int(n + 57.0), f.x, f.y - 1.0),
            grad(int(n + 58.0), f.x - 1.0, f.y - 1.0), fade(f.x)),
        fade(f.y));
    return res;
}

// Funkcja do generowania warstwowego szumu dla bardziej chmurowego efektu
float layered_perlin_noise(vec2 coord, float scale, float amplitude) {
    float noise = 0.0;
    float persistence = 0.5;  // Ustawienie wpływu kolejnych warstw szumu

    // Dodajemy kilka warstw szumu, aby uzyskać bardziej złożony efekt
    for (int i = 0; i < 5; i++) {
        noise += perlin_noise(coord * scale) * amplitude;
        scale *= 2.0;
        amplitude *= persistence;
    }
    return noise;
}

void fragment() {
    // Pobranie współrzędnych UV
    vec2 uv = UV;

    // Dodanie animacji do współrzędnych UV
    float speed = 0.0001; // Prędkość przesuwania chmur
    vec2 animated_uv = uv + vec2(TIME * speed, TIME * speed);

    // Parametry dla różnych chmur
    int num_clouds = 9; // Więcej chmur
    float cloud_size = 0.02; // Bardzo mały rozmiar chmury
    float scale = 9000.0; // Zmniejszona skala szumu

    // Inicjalizacja zmiennej do przechowywania wyniku końcowego
    float final_noise = 0.0;

    for (int i = 0; i < num_clouds; i++) {
        // Losowe przesunięcie dla każdej chmury
        float random_offset = float(i) * 0.01;
        vec2 cloud_center = vec2(fract(sin(float(i) * 0.1) * 43758.5453), fract(cos(float(i) * 0.1) * 43758.5453));

        // Modyfikacja współrzędnych UV dla efektu szumu
        vec2 cloud_uv = (animated_uv - cloud_center) * (scale * cloud_size);
        float noise = layered_perlin_noise(cloud_uv, 1.0, 1.0);

        // Wygładzanie i ograniczenie wartości szumu
        noise = smoothstep(0.3, 0.7, noise);
        final_noise = max(final_noise, noise);
    }

    // Ustawienie koloru chmur na podstawie uniformu
    vec4 color = vec4(cloud_color.rgb, cloud_color.a * final_noise * cloud_opacity);

    ALBEDO = color.rgb;
    ALPHA = color.a;
}
