function  comparaison
%vecteur des x
x=linspace (0,1,100);
%vecteur solution exacte 
y=(sin(2*(1-x))-sin(2*x))./(8*sin(2))+0.25*x.^2-1/8;
%vecteur solution approch�e pour N=1
y1=(-1/4).*x.*(1-x);
%vecteur solution approch�e pour N=2
y2=(7/38)*x.^3-(1/38)*x.^2-(6/38)*x;
hold on 
title('comparaison solution r�elle et solution de Rayleigh-ritz pour N=1 ou 2');
xlabel('x');
ylabel('phi');
axis([0 1 -0.07 0]);
plot(x,y,'r',x,y1,'y',x,y2,'-.b');
k=legend('solution exacte', 'solution approchee pour N=1','solution approchee pour N=2',3);
hold off

% Create the directory if it doesn't exist.
if ~exist('results/comparaison', 'dir')
    mkdir('results/comparaison');
end

% Base filename for the plot
baseFilename = 'results/comparaison/comparaison_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/comparaison/comparaison_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

end
