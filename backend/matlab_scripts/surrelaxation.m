function surrelaxation
  e=input('entrer la valeur de l_incertitude e');

  w=input('entrer le coefficient de surrelaxation w 0<w<2');
  while w>2||w==0

    disp('le processus diverge!')
    w=input('entree un coefficient w entre O et 2');

  end

  v1=1;
  V=zeros(4,6);
 
  bool=1;

  for j=4:6
    V(4,j)=v1;
  end

  while bool
    U=V;
    for j=2:6
      for i=2:4
        if j==6 && i~=4
          V(i,j)=(1-w)*U(i,j)+0.25*w*(2*V(i,j-1)+V(i+1,j)+V(i-1,j));
        elseif j<i
          V(i,j)=V(j,i);
        elseif i~=4
          V(i,j)=(1-w)*U(i,j)+0.25*w*(V(i+1,j)+V(i-1,j)+V(i,j+1)+V(i,j-1));
        end
      end
    end
    bool=(e<=max(max(abs(U-V))));
  end

  % Create the results directory if it doesn't exist
  if ~exist('results/surelaxation', 'dir')
      mkdir('results/surelaxation');
  end
  
  % Base filename
  baseFilename = 'results/surelaxation/surelaxation_results.txt';
  filename = baseFilename;
  count = 1;

  % Check if the file exists and update the filename with a count
  while exist(filename, 'file')
      filename = sprintf('results/surelaxation/surelaxation_results_%d.txt', count);
      count = count + 1;
  end

  % Open the file for writing results
  fileID = fopen(filename, 'w');

  % Write variables to the file
  fprintf(fileID, 'v1 = %f\n', v1);
  fprintf(fileID, 'e = %f\n', e);
  fprintf(fileID, 'w = %f\n', w);

  % Write the matrix V to the file
  fprintf(fileID, 'Matrix V:\n');
  for i = 1:size(V, 1)
      fprintf(fileID, '%f %f %f %f %f %f\n', V(i,:));
  end

  % Close the file
  fclose(fileID);