-- C A T A L O G  D A T A

--
-- Data for Name: cat_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

BEGIN;

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

INSERT INTO public.cat_matter (uuid, name) VALUES ('5995c9d5-636a-4acd-9530-7c6e008d071c', 'NA');
INSERT INTO public.cat_matter (uuid, name) VALUES ('9bc5a203-8488-4b18-857e-5d5c6d44a1b2', 'CIVIL');
INSERT INTO public.cat_matter (uuid, name) VALUES ('cf44ee41-201a-485c-a8b5-000940497cf9', 'DISCIPLINARIO');
INSERT INTO public.cat_matter (uuid, name) VALUES ('b77c3ef4-5241-440b-99e1-1b22cdc17535', 'FAMILIAR');
INSERT INTO public.cat_matter (uuid, name) VALUES ('52cbd99b-8187-46e2-8e0e-e5712ce7ae25', 'LABORAL');
INSERT INTO public.cat_matter (uuid, name) VALUES ('2a9cf1ba-4d5d-4a5c-807f-da7259a081d3', 'MENOR');
INSERT INTO public.cat_matter (uuid, name) VALUES ('034db92e-1a51-44c2-be4f-4743814d4c22', 'MIXTA');
INSERT INTO public.cat_matter (uuid, name) VALUES ('684527fe-952d-476f-b4a4-51d9ac4175ce', 'PENAL');


--
-- Data for Name: cat_poder; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('6e1cbb68-6073-4e47-ba92-02de52b52b41', 'PE', 'PODER EJECUTIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('312a1cec-85a5-4e66-a9e1-804d8c8de637', 'PL', 'PODER LEGISLATIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('151aead6-2e95-4e3c-bd27-f77d9e08375e', 'PJ', 'PODER JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('cb916a97-fdd1-4bab-b2e5-bc64585340bd', 'EF', 'EN FUNCIONES');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('d0dd1561-9f6a-46ce-99e9-3bfb5959322b', 'PEL', 'PODERES EJECUTIVO Y LEGISLATIVO');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('8491e45d-397b-4f67-bbfc-53e21bb53bf1', 'PEJ', 'PODERES EJECUTIVO Y JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('43aa1a46-f9fa-4e6d-8a77-57d3a73d7e10', 'PLJ', 'PODERES LEGISLATIVO Y JUDICIAL');
INSERT INTO public.cat_poder (uuid, short_name, name) VALUES ('242b4b62-f848-4c9c-af95-2ad0253b5aa3', 'PELJ', 'PODERES EJECUTIVO, LEGISLATIVO Y JUDICIAL');


--
-- Data for Name: cat_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (1, 'JUEZ PRIMERA', 'JUEZ', 'JUEZA', 'DE PRIMERA INSTANCIA');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (2, 'JUEZ DISTRITO', 'JUEZ', 'JUEZA', 'DE DISTRITO');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (3, 'MTSJ', 'MAGISTRADO', 'MAGISTRADA', 'DE TRIBUNAL SUPERIOR DE JUSTICIA');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (4, 'MTDJ', 'MAGISTRADO', 'MAGISTRADA', 'DE TRIBUNAL DE DISCIPLINA  JUDICIAL');
INSERT INTO public.cat_positions (id, cargo, male_name, female_name, long_name) VALUES (5, 'MSCJN', 'MINISTRO', 'MINISTRA', 'DE LA SUPREMA CORTE DE JUSTICIA DE LA NACIÓN');

COMMIT;
