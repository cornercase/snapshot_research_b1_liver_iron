b1_scale = [0:0.01:1.2];

magI = [0;0;1];
magT = [];



for n=b1_scale
    magT(:,end+1) = yrot(2*n*90*pi/180)*(xrot(n*90*pi/180)*magI);
end

atten = abs(cosd(2*90*b1_scale));
closeform = sqrt(...
    (-sind(2*90*b1_scale).*cosd(90*b1_scale)).^2 ...
     +...
     sind(90*b1_scale).^2).*sind(90*b1_scale);
 closeform2 = abs( cosd(2*90*b1_scale).*sind(90*b1_scale)+cosd(90*b1_scale).*sind(2*90*b1_scale));

eFig('temp attenuation');
plot(90.*b1_scale,abs(complex(magT(1,:),magT(2,:))),'r');
hold on;
plot(90.*b1_scale,atten,'g');
plot(90.*b1_scale,atten-abs(complex(magT(1,:),magT(2,:))),'b');
plot(90*b1_scale,closeform,'k');
plot(90*b1_scale,closeform2,'y');
hold off;