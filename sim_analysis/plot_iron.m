function [] = plot_iron(signal,varargin)
if ~isempty(varargin)
    echo = varargin{1};
else
    echo = 1;
end
signal = squeeze(signal);

trans_sig = squeeze(complex(signal(1,:,echo),signal(2,:,echo)));
long_sig = squeeze((signal(3,:,echo)));


figure;subplot(2,1,1);
plot(abs(trans_sig));
hold on;
plot(real(trans_sig),'r');
plot(imag(trans_sig),'g');
subplot(2,1,2);
plot(long_sig);