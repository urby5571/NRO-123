% Odpri datoteko
fid = fopen('naloga1_1.txt', 'r');

% Preberi prvo vrstico (ime)
ime = fgetl(fid);

% Preberi drugo vrstico (število vrstic in podatkov v vsaki vrstici)
druga_vrstica = fgetl(fid);
stevilo_vrstic = str2double(druga_vrstica);

% Ustvari prazen vektor t za shranjevanje podatkov
t = [];

% Preberi podatke in jih shrani v vektor t
for i = 1:stevilo_vrstic
    vrstica = fgetl(fid);
    podatki = str2num(vrstica); % pretvori vrstico v številski niz
    t = [t; podatki]; % dodaj podatke v vektor t
end

% Zapri datoteko
fclose(fid);

% Prikaži rezultat
disp('Podatki shranjeni v vektor t:');
disp(t);