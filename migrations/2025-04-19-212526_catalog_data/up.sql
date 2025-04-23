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


--
-- Data for Name: cat_matter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_matter (uuid, name) VALUES ('44ebdda1-0622-46db-9d7c-14fee2cad40c', 'NA');
INSERT INTO public.cat_matter (uuid, name) VALUES ('bd829a6a-9219-47f3-ae12-06be7be407b9', 'CIVIL');
INSERT INTO public.cat_matter (uuid, name) VALUES ('5d262a6f-1a5c-4964-b086-b271f0302e66', 'DISCIPLINARIO');
INSERT INTO public.cat_matter (uuid, name) VALUES ('cc1d47c3-f547-47f5-9bf4-e9058e50c825', 'FAMILIAR');
INSERT INTO public.cat_matter (uuid, name) VALUES ('586dec54-1bce-4fd9-a1ac-2a65013362c4', 'LABORAL');
INSERT INTO public.cat_matter (uuid, name) VALUES ('118f6595-7be3-4c26-85a5-c94c681ab5eb', 'MENOR');
INSERT INTO public.cat_matter (uuid, name) VALUES ('232951c0-2afd-48ae-a19a-1407a0831567', 'MIXTA');
INSERT INTO public.cat_matter (uuid, name) VALUES ('4dccab04-adc2-4f75-a0c2-48fc5fedf332', 'PENAL');


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

