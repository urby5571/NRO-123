#include <stdio.h>
#include <math.h>

// Definiramo število pi
#ifndef M_PI
#define M_PI 3.14159265
#endif

// Taylorjeva vrsta
double priblizekArctan(double vrednost, int Iteracije) {
    double vsota = 0.0;
    for (int i = 0; i < Iteracije; i++) {
        double clen = pow(-1, i) * pow(vrednost, 2 * i + 1) / (2 * i + 1);
        vsota += clen;
    }
    return vsota;
}

// Trapezna metoda
double trapeznaMetoda(double (*funkcija)(double, int), double spodnjaMeja, double zgornjaMeja, int Podintervali, int Koraki) {
    double korak = (zgornjaMeja - spodnjaMeja) / Podintervali;
    double integral = funkcija(spodnjaMeja, Koraki) + funkcija(zgornjaMeja, Koraki);

    for (int i = 1; i < Podintervali; i++) {
        double x = spodnjaMeja + i * korak;
        integral += 2 * funkcija(x, Koraki);
    }
    return integral * korak / 2;
}

double izrazi(double x, int Koraki) {
    double eksponent = exp(3 * x);
    double arctanDel = priblizekArctan(x / 2, Koraki);
    return eksponent * arctanDel;
}

int main() {
    // Parametri za integracijo
    double spodnjaMeja = 0.0;
    double zgornjaMeja = M_PI / 4;
    int Podintervali = 1000;
    int Koraki = 10;

    double vrednostIntegrala = trapeznaMetoda(izrazi, spodnjaMeja, zgornjaMeja, Podintervali, Koraki);

    printf("Rezultat numeriène integracije: %.15f\n", vrednostIntegrala);

    return 0;
}
