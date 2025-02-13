v1=1;
V=zeros(4,6);
e=0.0001;
bool=1;

for j=4:6
  V(4,j)=v1;
end

while bool
  U=V;
  for j=2:6
    for i=2:4
      if j==6 && i~=4
        V(i,j)=0.25*(2*V(i,j-1)+V(i+1,j)+V(i-1,j));
      elseif j<i
        V(i,j)=V(j,i);
      elseif i~=4
        V(i,j)=0.25*(V(i+1,j)+V(i-1,j)+V(i,j+1)+V(i,j-1));
      end
    end
  end
  bool=(e<=max(max(abs(U-V))));
end

% Create the results directory if it doesn't exist
if ~exist('results/relaxation', 'dir')
    mkdir('results/relaxation');
end

% Base filename
baseFilename = 'results/relaxation/relaxation_results.txt';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/relaxation/relaxation_results_%d.txt', count);
    count = count + 1;
end

% Open the file for writing results
fileID = fopen(filename, 'w');

% Write variables to the file
fprintf(fileID, 'v1 = %f\n', v1);
fprintf(fileID, 'e = %f\n', e);

% Write the matrix V to the file
fprintf(fileID, 'Matrix V:\n');
for i = 1:size(V, 1)
    fprintf(fileID, '%f %f %f %f %f %f\n', V(i,:));
end

% Close the file
fclose(fileID);