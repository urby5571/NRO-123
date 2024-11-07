clc;
clear all;

filename = 'naloga1_1.txt';
headerlinesIn=2;
delimiterIn='';

podatki = importdata(filename,delimiterIn,headerlinesIn);

t = podatki.data(:, 1)

filename = 'naloga1_2.txt';
fid = fopen(filename);
headerline = fgetl(fid);
P = [];
i = 1;

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line)
        value = str2double(line);
        P(i) = value;
        fprintf('%f\n',value);
        i = i + 1;
    end
end

figure(1);
plot(t, P);
xlabel('t[s]');
ylabel('P[W]');
title('Graf P(t)');


if length(t) < 2
    delta_t = 1;
    t = delta_t * (0:length(P)-1)';
else
    delta_t = t(2) - t(1);
end

integral = 0;

for i = 1:length(P)-1
    integral = integral + (P(i) + P(i+1)) * delta_t / 2;
end

x = trapz(t, P);

fprintf("Vrednost integrala: %f\n", integral)
fprintf("Vrednost integrala s trapz: %f\n", x)