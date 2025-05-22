--
-- Data for Name: cat_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_state (id_inegi, name) VALUES (0, 'Federal');
INSERT INTO public.cat_state (id_inegi, name) VALUES (1, 'Aguascalientes');
INSERT INTO public.cat_state (id_inegi, name) VALUES (2, 'Baja California');
INSERT INTO public.cat_state (id_inegi, name) VALUES (3, 'Baja California Sur');
INSERT INTO public.cat_state (id_inegi, name) VALUES (4, 'Campeche');
INSERT INTO public.cat_state (id_inegi, name) VALUES (5, 'Coahuila de Zaragoza');
INSERT INTO public.cat_state (id_inegi, name) VALUES (6, 'Colima');
INSERT INTO public.cat_state (id_inegi, name) VALUES (7, 'Chiapas');
INSERT INTO public.cat_state (id_inegi, name) VALUES (8, 'Chihuahua');
INSERT INTO public.cat_state (id_inegi, name) VALUES (9, 'CDMX');
INSERT INTO public.cat_state (id_inegi, name) VALUES (10, 'Durango');
INSERT INTO public.cat_state (id_inegi, name) VALUES (11, 'Guanajuato');
INSERT INTO public.cat_state (id_inegi, name) VALUES (12, 'Guerrero');
INSERT INTO public.cat_state (id_inegi, name) VALUES (13, 'Hidalgo');
INSERT INTO public.cat_state (id_inegi, name) VALUES (14, 'Jalisco');
INSERT INTO public.cat_state (id_inegi, name) VALUES (15, 'México');
INSERT INTO public.cat_state (id_inegi, name) VALUES (16, 'Michoacán de Ocampo');
INSERT INTO public.cat_state (id_inegi, name) VALUES (17, 'Morelos');
INSERT INTO public.cat_state (id_inegi, name) VALUES (18, 'Nayarit');
INSERT INTO public.cat_state (id_inegi, name) VALUES (19, 'Nuevo León');
INSERT INTO public.cat_state (id_inegi, name) VALUES (20, 'Oaxaca');
INSERT INTO public.cat_state (id_inegi, name) VALUES (21, 'Puebla');
INSERT INTO public.cat_state (id_inegi, name) VALUES (22, 'Querétaro');
INSERT INTO public.cat_state (id_inegi, name) VALUES (23, 'Quintana Roo');
INSERT INTO public.cat_state (id_inegi, name) VALUES (24, 'San Luis Potosí');
INSERT INTO public.cat_state (id_inegi, name) VALUES (25, 'Sinaloa');
INSERT INTO public.cat_state (id_inegi, name) VALUES (26, 'Sonora');
INSERT INTO public.cat_state (id_inegi, name) VALUES (27, 'Tabasco');
INSERT INTO public.cat_state (id_inegi, name) VALUES (28, 'Tamaulipas');
INSERT INTO public.cat_state (id_inegi, name) VALUES (29, 'Tlaxcala');
INSERT INTO public.cat_state (id_inegi, name) VALUES (30, 'Veracruz de Ignacio de la Llave');
INSERT INTO public.cat_state (id_inegi, name) VALUES (31, 'Yucatán');
INSERT INTO public.cat_state (id_inegi, name) VALUES (32, 'Zacatecas');


--
-- Data for Name: cat_district; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_district (id, name, id_inegi) VALUES (0, 'ESTATAL', 0);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (1, 'ABRAHAM GONZÁLEZ', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (2, 'ANDRÉS DEL RÍO', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (3, 'ARTEAGA', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (4, 'BENITO JUÁREZ', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (5, 'BRAVOS', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (6, 'CAMARGO', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (7, 'GALEANA', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (8, 'GUERRERO', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (9, 'HIDALGO', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (10, 'JIMÉNEZ', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (11, 'MANUEL OJINAGA', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (12, 'MINA', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (13, 'MORELOS', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (14, 'RAYON', 8);
INSERT INTO public.cat_district (id, name, id_inegi) VALUES (9999, 'FEDERAL', 0);


--
-- Data for Name: cat_matter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_matter VALUES ('bd829a6a-9219-47f3-ae12-06be7be407b9', 'CIVIL');
INSERT INTO public.cat_matter VALUES ('5d262a6f-1a5c-4964-b086-b271f0302e66', 'DISCIPLINARIO');
INSERT INTO public.cat_matter VALUES ('cc1d47c3-f547-47f5-9bf4-e9058e50c825', 'FAMILIAR');
INSERT INTO public.cat_matter VALUES ('586dec54-1bce-4fd9-a1ac-2a65013362c4', 'LABORAL');
INSERT INTO public.cat_matter VALUES ('118f6595-7be3-4c26-85a5-c94c681ab5eb', 'MENOR');
INSERT INTO public.cat_matter VALUES ('4dccab04-adc2-4f75-a0c2-48fc5fedf332', 'PENAL');
INSERT INTO public.cat_matter VALUES ('44ebdda1-0622-46db-9d7c-14fee2cad40c', 'N/D');
INSERT INTO public.cat_matter VALUES ('232951c0-2afd-48ae-a19a-1407a0831567', 'MIXTO');
INSERT INTO public.cat_matter VALUES ('86674281-395d-4f5c-94a5-403ac80da52a', 'ADMINISTRATIVA');
INSERT INTO public.cat_matter VALUES ('73bf69cf-98d6-497d-9f01-397731424892', 'ADMINISTRATIVA ESPECIALIZADO EN COMPETENCIA ECONÓMICA, RADIODIFUSIÓN Y TELECOMUNICACIONES');
INSERT INTO public.cat_matter VALUES ('730c92ae-9feb-4131-89ac-a5359a8c42a0', 'ADMINISTRATIVA Y CIVIL');
INSERT INTO public.cat_matter VALUES ('973c2829-8030-47b4-a7d7-c5c7c025914f', 'ADMINISTRATIVO Y DE TRABAJO');
INSERT INTO public.cat_matter VALUES ('32c49f08-6b2a-499a-a6bf-e921823a26d8', 'APELACIÓN EN MATS. CIVIL Y ADMVA. ESPECIALIZADO EN COMPETENCIA ECONÓMICA, RADIODIFUSIÓN Y TELECOMUNICACIONES.');
INSERT INTO public.cat_matter VALUES ('b0730a9e-27fb-4631-a97c-f1cbc3b9db69', 'CIVIL Y DE TRABAJO');
INSERT INTO public.cat_matter VALUES ('bd2d09f8-c0a1-481b-baea-58328d7dd123', 'PENAL ADMINISTRATIVO');
INSERT INTO public.cat_matter VALUES ('5622d9b6-cd7a-43d6-a3f7-497779704543', 'PENAL Y CIVIL');
INSERT INTO public.cat_matter VALUES ('a2a1ab1c-c3cc-4b60-8d4e-61c5d25675d2', 'PENAL Y DE TRABAJO');
INSERT INTO public.cat_matter VALUES ('0695c75e-83f5-43ed-b74f-96982c1e9d78', 'TRABAJO');
INSERT INTO public.cat_matter VALUES ('eab19911-36c5-4607-a564-2f9663910328', 'PENAL Y AMPARO EN MATERIA PENAL');
INSERT INTO public.cat_matter VALUES ('1d14c94e-8ae6-47f1-b4ef-7a227eaa4dbc', 'AMPARO CIVIL, ADMINISTRATIVA Y DE TRABAJO Y JUICIOS FEDERALES');
INSERT INTO public.cat_matter VALUES ('1cdb11b5-3f10-4ea6-a69b-bb3fcf856ed0', 'MERCANTIL');
INSERT INTO public.cat_matter VALUES ('4b829a90-29d3-41f0-b04b-1d71788f0e44', 'ADMINISTRATIVA Y DEL TRABAJO');
INSERT INTO public.cat_matter VALUES ('50e1cafc-2810-4b0f-afae-38bdf439bbad', 'AMPARO Y JUICIOS FEDERALES');


--
-- Data for Name: cat_poder; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('7c29d650-0bb8-4412-8b09-d74e20bd3052', 'PE', 'PODER EJECUTIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('e5fa9cae-06f4-4c37-904e-511924019ece', 'PL', 'PODER LEGISLATIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('c7ef7124-0ff3-4084-8d6d-cd246ebb0d6c', 'PJ', 'PODER JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('f4a69bea-1806-475f-b5a4-6bb0c927c449', 'EF', 'EN FUNCIONES');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('b6b88996-aa72-4a91-90df-2b4b724b31ff', 'PEL', 'PODERES EJECUTIVO Y LEGISLATIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('431f3cd0-7d45-4c17-a8a5-60be82503f56', 'PEJ', 'PODERES EJECUTIVO Y JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('3226fc85-7a07-4fb4-9ade-1c12c8c1d129', 'PLJ', 'PODERES LEGISLATIVO Y JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('88ab0482-9d38-4b5c-849e-8ebc4ec22035', 'PELJ', 'PODERES EJECUTIVO, LEGISLATIVO Y JUDICIAL');


--
-- Data for Name: cat_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (1, 'JUEZ PRIMERA', 'JUEZ', 'JUEZA', 'DE PRIMERA INSTANCIA');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (2, 'JUEZ DISTRITO', 'JUEZ', 'JUEZA', 'DE DISTRITO');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (3, 'MTSJ', 'MAGISTRADO', 'MAGISTRADA', 'DE TRIBUNAL SUPERIOR DE JUSTICIA');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (4, 'MTDJ', 'MAGISTRADO', 'MAGISTRADA', 'DE TRIBUNAL DE DISCIPLINA  JUDICIAL');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (5, 'MSCJN', 'MINISTRO', 'MINISTRA', 'DE LA SUPREMA CORTE DE JUSTICIA DE LA NACIÓN');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (6, 'MSSTE', 'MAGISTRADO', 'MAGISTRADA', 'DE LA SALA SUPERIOR DEL TRIBUNAL ELECTORAL');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (7, 'MSRTE', 'MAGISTRADO', 'MAGISTRADA', 'DE LA SALA REGIONAL DEL TRIBUNAL ELECTORAL');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (8, 'MTCCA', 'MAGISTRADO', 'MAGISTRADA', 'DE TRIBUNALES COLEGIADOS DE CIRCUITO Y COLEGIADOS DE APELACIÓN');

