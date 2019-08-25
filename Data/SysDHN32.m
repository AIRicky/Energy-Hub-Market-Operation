Sb = 10; % MW
Taob = 100; % K
% Mb = Sb/cp/Taob;% 100/4.2 = 23.8 Kg/s
Mb = 23.8;
m_adj_factor = 2;
% DHN Pipe
% No.(1)|From(2)|To(3)|L(4)m|u_T(5)|u_p(6)|ms(7)|diameter(8)
pipe = [
    1	1	2	257.6	0.321	0.4  4.8	125
    2	2	3	97.5	0.21	0.4	 0.65	40
    3	2	4	51      0.21	0.4	 0.88	40
    4	2	5	59.5	0.327	0.4	 3.27	100
    5	5	6	271.3	0.189	0.4	 0.67	32
    6	7	5	235.4	0.236	0.4	 0.88	65 
    7	7	8	177.3	0.21	0.4	 0.66	40
    8	7	9	102.8	0.21	0.4	 0.66	40
    9	7	10	247.7	0.21	0.4	 0.66	40
    10	5	11	160.8	0.327	0.4	 3.48	100
    11	11	12	129.1	0.21	0.4	 0.66	40
    12	11	13	186.1	0.327	0.4	 4.19	100
    13	13	14	136.2	0.278	0.4	 4.19	80
    14	14	15	41.8	0.219	0.4	 1      50
    15	15	16	116.8	0.189	0.4	 0.5	32
    16	15	17	136.4	0.189	0.4	 0.5	32
    17	14	18	136.4	0.189	0.4	 1      32
    18	14	19	44.9	0.278	0.4	 2.19	80
    19	19	20	136.4	0.189	0.4	 0.5	32
    20	19	21	134.1	0.189	0.4	 0.5	32
    21	19	22	41.7	0.236	0.4	 1.19	65
    22	22	23	161.1	0.189	0.4	 0.52	32
    23	22	24	134.2	0.189	0.4	 0.52	32
    24	22	25	52.1	0.236	0.4  0.15	65 
    25	25	26	136     0.189	0.4	 0.81	32
    26	25	27	123.3	0.189	0.4	 0.81	32
    27	28	25	61.8	0.21	0.4	 1.46	40
    28	28	29	95.2	0.189	0.4	 0.65	32
    29	28	30	105.1	0.189	0.4	 0.65	32
    30	31	28	70.6	0.321	0.4	 2.76	125
    31	31	7	261.8	0.321	0.4	 2.86	125
    32  32	11	201.3	0.321	0.4	 1.37	125
];
N_Pipe = size(pipe,1);
pipe_i = pipe(:,2);
pipe_j = pipe(:,3);
L_pipe = pipe(:,4);
lamada_pipe = pipe(:,5)/1e3/10/10;%
miu_pipe = pipe(:,6);
ms_pipe = pipe(:,7)/m_adj_factor;
mr_pipe = pipe(:,7)/m_adj_factor;
ms_pipe = ms_pipe/Mb; % p.u.
mr_pipe = mr_pipe/Mb; % p.u.

psai = zeros(N_Pipe,1); % pipe loss factor
psai = exp(-lamada_pipe.*L_pipe./(cp*ms_pipe)); % p.u. 
psaiR = psai;
psaiS = psai;

% Heat Node
%  No(1)|Hd(2)|tao_S_max(3)|tao_S_min(4)|tao_R_max(5)|
%        tao_R_min(6)|mass flow(7)
heatnode = [ %MW      %¡æ  % 
    % Assumed that there is no heat load at the interconnected point
    1	0       100	70	65	35  4.8  % source
    2	0       100	70	65	35  0
    3	0.107	100	70	65	35  0.65 % load
    4	0.145	100	70	65	35  0.88 % load
    5	0       100	70	65	35  0
    6	0.107	100	70	65	35  0.67 % load
%     7	0.107	120	70	65	25  0
    7	0   	100	70	65	35  0
    8	0.107	100	70	65	35  0.66 % load
    9	0.107	100	70	65	35  0.66 % load
    10	0.107	100	70	65	35  0.66 % load
%     11	0.145	120	70	65	25  0
    11	0   	100	70	65	35  0
    12	0.107	100	70	65	35  0.66 % load
    13	0       100	70	65	35  0
%     14	0.0805	120	70	65	25  0
    14	0       100	70	65	35  0
    15	0       100	70	65	35  0
    16	0.0805	100	70	65	35  0.5 % load
    17	0.0805	100	70	65	35  0.5 % load
%     18	0.0805	120	70	65	25  1
    18	0.161	100	70	65	35  1   %  load
    19	0       100	70	65	35  0
    20	0.0805	100	70	65	35  0.5 %  load
    21	0.0805	100	70	65	35  0.5 %  load
    22	0       100	70	65	35  0
%     23	0.107	120	70	65	25  0.52
%     24	0.107	120	70	65	25  0.52
    23	0.0807	100	70	65	35  0.52 %  load
    24	0.0807	100	70	65	35  0.52 %  load
    25	0       100	70	65	35  0
%     26	0.166	120	70	65	25  0.81
%     27	0.166	120	70	65	25  0.81
    26	0.1257	100	70	65	35  0.81 %  load
    27	0.1257	100	70	65	35  0.81 %  load
    28	0       100	70	65	35  0
    29	0.107	100	70	65	35  0.65 %  load
    30	0.107	100	70	65	35  0.65 %  load
    31	0       100	70	65	35  5.62 %  source
    32	0       100	70	65	35  1.37 %  source
];
N_Node = length(heatnode(:,1));

% Heat Gen
% % No.(1)|Hg_max(2)|Hg_min(3)|C_A(4)/MW^2|C_B(5)MW|C_(6)|Mass flow(7) %
heatGB = [% MW                  % kg/s
    1   1.0  0.0  0.15 20 0 4.8
    32  1.0  0.0  0.16 18 0 1.37
%     1   1.0  0.0  0.25 40 0 4.8
%     32  1.0  0.0  0.26 36 0 1.37
];
Ind_GB = heatGB(:,1);
Hg_GB_max = zeros(N_Node,NT);
Hg_GB_max(Ind_GB,:) = repmat(heatGB(:,2),1,NT); % MW
Hg_GB_max = Hg_GB_max/Sb; % p.u.
alphaGB = zeros(N_Node,1);
alphaGB(Ind_GB,:) = heatGB(:,4)*(Sb^2);% p.u
betaGB = zeros(N_Node,1);
betaGB(Ind_GB,:) = heatGB(:,5)*Sb; % p.u.

heatnode(:,2) = heatnode(:,2)/Sb; % p.u.
Nd_Hd = find(heatnode(:,2)>0); % load
Nd_Hs = [Ind_GB' Ind_EH_DHN]; % adjust
N_Node = size(heatnode,1);
m_Hs = zeros(1,N_Node); % source
m_Hs(Nd_Hs) = heatnode(Nd_Hs,7)/m_adj_factor;
m_Hs = m_Hs/Mb; % p.u.
m_Hd = heatnode(:,7)/m_adj_factor;% load
m_Hd(Nd_Hs) = 0; % 
m_Hd = m_Hd/Mb; % p.u.
H_ratio = heatnode(:,2)/sum(heatnode(:,2)); 
tao_NS_max = heatnode(:,3); % K
tao_NS_min = heatnode(:,4);
tao_NR_max = heatnode(:,5);
tao_NR_min = heatnode(:,6);
tao_NS_max = tao_NS_max/Taob; % p.u.
tao_NS_min = tao_NS_min/Taob; % p.u. 
tao_NR_max = tao_NR_max/Taob; % p.u.
tao_NR_min = tao_NR_min/Taob; % p.u.

% structure
DataDHN.IndHd = Nd_Hd;
DataDHN.IndHs = Nd_Hs;
DataDHN.IndEH = Ind_EH_DHN;
DataDHN.IndGB = Ind_GB;