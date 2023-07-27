shader_type canvas_item;

uniform float zoom;
uniform float center_x;
uniform float center_y;
uniform int num_iterations;

// Converts HSV (Hue, Saturation, Value) to RGB (Red, Green, Blue)
vec3 hsv_to_rgb(vec3 hsv) {
    float h = hsv.x;
    float s = hsv.y;
    float v = hsv.z;

    float c = v * s;
    float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
    float m = v - c;

    vec3 rgb;

    if (h < 60.0) {
        rgb = vec3(c, x, 0.0);
    } else if (h < 120.0) {
        rgb = vec3(x, c, 0.0);
    } else if (h < 180.0) {
        rgb = vec3(0.0, c, x);
    } else if (h < 240.0) {
        rgb = vec3(0.0, x, c);
    } else if (h < 300.0) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }

    return rgb + vec3(m);
}

struct ComplexNumber {
	float real;
	float imaginary;
};

ComplexNumber add_complex(ComplexNumber a, ComplexNumber b) {
	return ComplexNumber(a.real + b.real, a.imaginary + b.imaginary);	
}

ComplexNumber multiply_complex(ComplexNumber a, ComplexNumber b) {
	return ComplexNumber(a.real*b.real - a.imaginary*b.imaginary, a.real*b.imaginary + a.imaginary*b.real);
}

ComplexNumber square_complex(ComplexNumber a) {
	return multiply_complex(a, a);
}

float distance_complex(ComplexNumber a) {
	return sqrt(a.real*a.real + a.imaginary*a.imaginary);
}

void fragment() {
	// Do math to find complex test point
	mat2 x_reflection = mat2(vec2(1, 0), vec2(0, -1));
	vec2 test_space = x_reflection * UV + vec2(-0.5, 0.5);
	vec2 test_point = test_space * zoom + vec2(center_x, center_y);
	ComplexNumber constant = ComplexNumber(test_point.x, test_point.y);
	ComplexNumber critical_point = ComplexNumber(0.0, 0.0);
	int bounded_iterations = 0;
	bool bounded = true;
	
	// Run through iterations
	for (int i = 0; i < num_iterations; i++) {
		critical_point = square_complex(add_complex(critical_point, constant));

		if (distance_complex(critical_point) > TAU) {
			bounded = false;
			bounded_iterations = i;
			break;
		}
	}

	if (bounded == true) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		vec3 hsv_boundary_color = vec3(mix(0.0, 360.0, float(bounded_iterations)/float(num_iterations)), 1.0, 1.0);
		vec3 rgb_boundary_color = hsv_to_rgb(hsv_boundary_color);
		COLOR = vec4(rgb_boundary_color.g, rgb_boundary_color.b, rgb_boundary_color.r, 1.0);
	}
}
