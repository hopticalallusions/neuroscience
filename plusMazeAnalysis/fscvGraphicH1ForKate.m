aa=readFscvRaw('/Volumes/SILVRSURFER/fscvphys/day0/ch2Sugars/offset1ch2_134');

figure; plot(mean(aa(:,270:280),2)

qq=aa; for ii=1:600; qq(:,ii)=aa(:,ii)-mean(aa(:,41:51),2); end; imagesc(qq)

cm=[0	0	0;...
0	255	0;...
0	250	0;...
0	245	0;...
0	240	0;...
0	235	0;...
0	230	0;...
0	227	0;...
0	224	0;...
0	220	0;...
0	216	0;...
0	212	0;...
0	208	0;...
0	203	0;...
0	199	0;...
0	195	0;...
0	190	0;...
0	184	0;...
0	181	0;...
0	176	0;...
0	172	0;...
0	168	0;...
0	164	0;...
0	160	0;...
0	154	0;...
0	150	0;...
0	146	0;...
0	142	0;...
0	138	0;...
0	134	0;...
0	132	0;...
0	130	0;...
0	132	8;...
0	134	16;...
0	136	25;...
0	139	30;...
0	142	35;...
0	144	40;...
0	146	45;...
0	149	50;...
0	152	61;...
0	155	72;...
0	159	79;...
0	162	88;...
0	165	106;...
0	168	114;...
0	172	120;...
0	177	128;...
6	170	129;...
12	165	130;...
16	158	131;...
20	150	132;...
24	144	133;...
28	138	134;...
32	135	135;...
38	132	136;...
44	121	136;...
55	110	136;...
63	95	136;...
70	85	136;...
80	75	136;...
89	65	136;...
92	48	136;...
95	42	136;...
110	37	136;...
118	20	110;...
125	10	90;...
136	4	76;...
76	7	76;...
82	13	76;...
80	20	62;...
93	27	51;...
106	34	40;...
112	38	32;...
118	43	28;...
124	50	25;...
130	56	13;...
136	64	11;...
141	51	0;...
147	60	0;...
157	75	0;...
163	93	0;...
168	101	0;...
172	108	0;...
176	116	0;...
180	123	0;...
184	131	0;...
188	138	0;...
192	146	0;...
196	153	0;...
200	161	0;...
204	168	0;...
208	176	0;...
212	183	0;...
216	191	0;...
220	198	0;...
224	206	0;...
228	213	0;...
233	221	0;...
235	229	0;...
238	238	0;...
240	240	0;...
0	0	7;...
0	0	14;...
0	0	21;...
0	0	28;...
0	0	35;...
0	0	42;...
0	0	49;...
0	0	56;...
0	0	63;...
0	0	70;...
0	0	77;...
0	0	84;...
0	0	91;...
0	0	98;...
0	0	105;...
0	0	112;...
0	0	119;...
0	0	126;...
0	0	133;...
0	0	140;...
0	0	147;...
0	0	154;...
0	0	161;...
0	0	168;...
0	0	175;...
0	0	182;...
0	0	189;...
0	0	196;...
0	0	203;...
0	0	210;...
0	0	217;...
0	0	224;...
0	0	231;...
0	0	236;...
0	0	0];

cm=cm/255;

colormap(cm)