function save_phil2_plot
    x = [0:0.1:1];
    y2 = 3*sqrt(210)*(x-x.^2) - 2*sqrt(210)*(x-x.^3);
    y1 = sqrt(2)*sin(2*pi*x);
    
    % Create the plot
    figure('Visible', 'off'); % Create a figure without displaying it
    plot(x, y2, 'b-', x, y1, 'r-');
    xlabel('x');
    ylabel('phi');
    grid on;

    % Create the results directory if it doesn't exist
    if ~exist('results/phil2', 'dir')
        mkdir('results/phil2');
    end
    
    % Base filename for the plot
    baseFilename = 'results/phil2/phil2_plot.png';
    filename = baseFilename;
    count = 1;

    % Check if the file exists and update the filename with a count
    while exist(filename, 'file')
        filename = sprintf('results/phil2/phil2_plot_%d.png', count);
        count = count + 1;
    end

    % Save the plot to a file
    saveas(gcf, filename);

    % Close the figure
    close(gcf);
end
