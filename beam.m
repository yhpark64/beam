stlFile = 'Part1.STL';

%% params
E = 8e10*1e-6;   
nu = 0.3;   
rho = 2700*1e-12;    
gravity = [0 0 -9.80665];

origins = [0 0 -1567/2;
    0 0 1567/2];

numFrames = size(origins,1);

femodel = createpde('structural','modal-solid');
importGeometry(femodel,stlFile);

structuralProperties(femodel, ...
    'YoungsModulus',E, ...
    'PoissonsRatio',nu, ...
    'MassDensity',rho);

generateMesh(femodel, ...
    'GeometricOrder','quadratic','Hmax',1e2,'Hmin',1e2);

faceIDs = [1, 3];   

for i=1:size(origins,1)
    structuralBC(femodel, ...
        'Face',faceIDs(i), ...
        'Constraint','multipoint', ...
        'Reference',origins(i,:));
end

%% reduction
rom = reduce(femodel,'FrequencyRange',[0 20]*(2*pi));
