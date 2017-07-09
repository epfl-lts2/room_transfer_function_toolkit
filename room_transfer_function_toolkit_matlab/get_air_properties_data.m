function [c, rho, z] = get_air_properties_data(TEMPERATURE)
% c - sound speed
% rho - air density
% z - acoustic impedance
if(TEMPERATURE <= -25)     c = 315.77; rho = 1.4224; z = 449.1;
elseif(TEMPERATURE <= -20) c = 318.94; rho = 1.3943; z = 444.6;
elseif(TEMPERATURE <= -15) c = 322.07; rho = 1.3673; z = 440.3;
elseif(TEMPERATURE <= -10) c = 325.18; rho = 1.3413; z = 436.1;
elseif(TEMPERATURE <= -5)  c = 328.25; rho = 1.3163; z = 432.1;
elseif(TEMPERATURE <= 0)   c = 331.30; rho = 1.2922; z = 428.0;
elseif(TEMPERATURE <= 5)   c = 334.32; rho = 1.2690; z = 424.3;
elseif(TEMPERATURE <= 10)  c = 337.31; rho = 1.2466; z = 420.5;
elseif(TEMPERATURE <= 15)  c = 340.27; rho = 1.2250; z = 416.9;
elseif(TEMPERATURE <= 20)  c = 343.21; rho = 1.2041; z = 413.3;
elseif(TEMPERATURE <= 25)  c = 346.13; rho = 1.1839; z = 409.4;
elseif(TEMPERATURE <= 30)  c = 349.02; rho = 1.1644; z = 406.5;
else  c = 351.88; rho = 1.1455; z = 403.2;
end;