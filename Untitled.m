

tic;
a = randn([1,1e7]);
cos(a);
cos(a.*a);
cos(a.*a.*a);

toc

tic;

a_g = randn([1,1e7],'gpuArray');
cos(a_g);
cos(a_g.*a_g);
cos(a_g.*a_g.*a_g);

toc