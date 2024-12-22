#include <stdio.h>
#include <math.h>


// Taylorjeva vrsta
double priblizekArctan(double vrednost, int iteracije) {
    double vsota = 0.0;
    for (int i = 0; i < iteracije; i++) {
        double clen = pow(-1, i) * pow(vrednost, 2 * i + 1) / (2 * i + 1);
        vsota += clen;
    }
    return vsota;
}

// Trapezna metoda
double trapeznaMetoda(double (*funkcija)(double, int), double spodnjaMeja, double zgornjaMeja, int podintervali, int koraki) {
    double korak = (zgornjaMeja - spodnjaMeja) / podintervali;
    double integral = funkcija(spodnjaMeja, koraki) + funkcija(zgornjaMeja, koraki);

    for (int i = 1; i < podintervali; i++) {
        double x = spodnjaMeja + i * korak;
        integral += 2 * funkcija(x, koraki);
    }
    return integral * korak / 2;
}

double izrazi(double x, int koraki) {
    double eksponent = exp(3 * x);
    double arctanDel = priblizekArctan(x / 2, koraki);
    return eksponent * arctanDel;
}
// Definiramo število pi
#ifndef M_PI
#define M_PI 3.14159265
#endif

int main() {
    // Parametri za integracijo
    double spodnjaMeja = 0.0;
    double zgornjaMeja = M_PI / 4;
    int podintervali = 1000;
    int koraki = 10;

    double vrednostInt = trapeznaMetoda(izrazi, spodnjaMeja, zgornjaMeja, podintervali, koraki);

    printf("Približna vrednost numeriène integracije: %.15f\n", vrednostInt);

    return 0;
}
