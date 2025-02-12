function general2

% Add error handling to check if the 'general' function exists.
if ~exist('general', 'file')
    error('The "general" function is not found in the current path.');
end

[q1, p1] = general(2, 2*pi/9);
[q2, p2] = general(6, 2*pi/9);
[q3, p3] = general(10, 2*pi/9);
[q4, p4] = general(15, 2*pi/9);
[q5, p5] = general(25, 2*pi/9);
[q6, p6] = general(50, 2*pi/9);

% Create the directory if it doesn't exist.
if ~exist('results/general2', 'dir')
    mkdir('results/general2');
end

% Create the plot without displaying it
figure('Visible', 'off');
subplot(2,1,1);
plot(q1, p1, q2, p2, q3, p3, q4, p4, q5, p5, q6, p6);
legend('n=2','n=6','n=10','n=15','n=25','n=50');
ylabel('E(\Phi)');
title('\Phi = 40');

[q10, p10] = general(2, 0);
[q20, p20] = general(6, 0);
[q30, p30] = general(10, 0);
[q40, p40] = general(15, 0);
[q50, p50] = general(25, 0);
[q60, p60] = general(50, 0);

subplot(2,1,2);
plot(q10, p10, q20, p20, q30, p30, q40, p40, q50, p50, q60, p60);
legend('n=2','n=6','n=10','n=15','n=25','n=50');
xlabel('-\pi \leq \Phi \leq \pi (gradu en rad)');
ylabel('E(\Phi)');
title('\Phi = 0');

% Base filename for the plot
baseFilename = 'results/general2/general2_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/general2/general2_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

% Close the figure
close(gcf);
end
