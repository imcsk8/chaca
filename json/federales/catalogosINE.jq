def get_estudios($idGrado):
    {
        gradosEstudio: [
          {
            "estatus": "Cédula profesional",
            "idGrado": 1,
            "descripcionGrado": "Postdoctorado"
          },
          {
            "estatus": "Título profesional",
            "idGrado": 2,
            "descripcionGrado": "Postdoctorado"
          },
          {
            "estatus": "Concluido",
            "idGrado": 3,
            "descripcionGrado": "Postdoctorado"
          },
          {
            "estatus": "Cédula profesional",
            "idGrado": 5,
            "descripcionGrado": "Doctorado"
          },
          {
            "estatus": "Título profesional",
            "idGrado": 6,
            "descripcionGrado": "Doctorado"
          },
          {
            "estatus": "Concluido",
            "idGrado": 7,
            "descripcionGrado": "Doctorado"
          },
          {
            "estatus": "Cédula profesional",
            "idGrado": 9,
            "descripcionGrado": "Maestría"
          },
          {
            "estatus": "Título profesional",
            "idGrado": 10,
            "descripcionGrado": "Maestría"
          },
          {
            "estatus": "Concluido",
            "idGrado": 11,
            "descripcionGrado": "Maestría"
          },
          {
            "estatus": "Cédula profesional",
            "idGrado": 13,
            "descripcionGrado": "Especialidad"
          },
          {
            "estatus": "Título profesional",
            "idGrado": 14,
            "descripcionGrado": "Especialidad"
          },
          {
            "estatus": "Concluido",
            "idGrado": 15,
            "descripcionGrado": "Especialidad"
          },
          {
            "estatus": "Cédula profesional",
            "idGrado": 17,
            "descripcionGrado": "Licenciatura"
          },
          {
            "estatus": "Título profesional",
            "idGrado": 18,
            "descripcionGrado": "Licenciatura"
          },
          {
            "estatus": "Concluido",
            "idGrado": 19,
            "descripcionGrado": "Licenciatura"
          }
        ]
    }.gradosEstudio[]
    |
    select(.idGrado == $idGrado).descripcionGrado
;

def sum_powers($powers):
    if ($powers | length) == 1 then
        $powers[0]
    else
        # 4 es "En funciones"
        if ($powers | contains([4])) then
            4
        else
            reduce $powers[] as $item (0; . + $item) + 4
        end
    end
;


# Returns the database ID of the proponent power
def get_poder($id_poder):
    # appPoderId is a quick and dirty hack that has the current database
    # cat_poderes uuid, this is going to be different because the migrations create
    # random uuids (maybe leave this fixed in the migration?)
    # each candidate can be nominated by one, two or three powers
    # for the compound nominations we sum the ids of each power plus 4 which is the las
    # id of the simple powers.
    {
      "fecha": "Mon May 12 00:00:06 GMT-06:00 2025",
      "poderesUnion": [
        {
          "siglas": "PE",
          "nombre": "Poder Ejecutivo Federal",
          "idPoderUnion": 1,
          "appPoderId": "7c29d650-0bb8-4412-8b09-d74e20bd3052"
        },
        {
          "siglas": "PL",
          "nombre": "Poder Legislativo Federal",
          "idPoderUnion": 2,
          "appPoderId": "e5fa9cae-06f4-4c37-904e-511924019ece"
        },
        {
          "siglas": "PJ",
          "nombre": "Poder Judicial de la Federación",
          "idPoderUnion": 3,
          "appPoderId": "c7ef7124-0ff3-4084-8d6d-cd246ebb0d6c"
        },
        {
          "siglas": "EF",
          "nombre": "En Funciones",
          "idPoderUnion": 4,
          "appPoderId": "f4a69bea-1806-475f-b5a4-6bb0c927c449"
        },
        {
          "siglas": "PEL",
          "nombre": "PODERES EJECUTIVO Y LEGISLATIVO",
          "idPoderUnion": 7, # id_ejecutivo + id_legislativo + 4: 1 + 2 + 4 = 7
          "appPoderId": "b6b88996-aa72-4a91-90df-2b4b724b31ff"
        },
        {
          "siglas": "PEJ",
          "nombre": "PODERES EJECUTIVO Y JUDICIAL",
          "idPoderUnion": 8, # id_ejecutivo + id_judicial + 4: 1 + 3 + 4 = 8
          "appPoderId": "431f3cd0-7d45-4c17-a8a5-60be82503f56"
        },
        {
          "siglas": "PLJ",
          "nombre": "PODERES LEGISLATIVO Y JUDICIAL",
          "idPoderUnion": 9, # id_legislativo + id_judicial + 4: 2 + 3 + 4 = 9
          "appPoderId": "3226fc85-7a07-4fb4-9ade-1c12c8c1d129"
        },
        {
          "siglas": "PELJ",
          "nombre": "PODERES EJECUTIVO, LEGISLATIVO Y JUDICIAL",
          "idPoderUnion": 10, # id_ejecutivo + id_legislativo + id_judicial + 4: 1 + 2 + 3 + 4 = 10
          "appPoderId": "88ab0482-9d38-4b5c-849e-8ebc4ec22035"
        }

      ]
    }.poderesUnion[]
    |
    select(.idPoderUnion == $id_poder)
;


# appCargo and appCargoId are taken from cat_positions
# appCargo should be set as a jq argument: jq --arg CARGO "MSTE"
# This function is just to give semantics in the command line
def get_cargo($idCargo):
    {
        "cargos": [
          {
            "idTipoCandidatura": 6,
            "nombreCombo": "Ministra/o Suprema Corte de Justicia de la Nación",
            "nombreCorto": "Ministra/o Suprema Corte de Justicia de la Nación",
            "appCargo": "MSCJN",
            "appCargoId": 5
          },
          {
            "idTipoCandidatura": 7,
            "nombreCombo": "Magistratura Tribunal de Disciplina Judicial",
            "nombreCorto": "Magistratura Tribunal de Disciplina Judicial",
            "appCargo": "MTDJ",
            "appCargoId": 4
          },
          {
            "idTipoCandidatura": 8,
            "nombreCombo": "Magistratura Sala Superior del Tribunal Electoral del Poder Judicial de la Federación",
            "nombreCorto": "Magistratura Sala Superior del TE del PJF",
            "appCargo": "MSSTE",
            "appCargoId": 6
          },
          {
            "idTipoCandidatura": 9,
            "nombreCombo": "Magistratura Salas Regionales del Tribunal Electoral del Poder Judicial de la Federación",
            "nombreCorto": "Magistratura Salas Regionales del TE del PJF",
            "appCargo": "MSRTE",
            "appCargoId": 7
          },
          {
            "idTipoCandidatura": 10,
            "nombreCombo": "Magistraturas de Tribunales Colegiados de Circuito y Colegiados de Apelación",
            "nombreCorto": "Magistraturas de Tribunales Colegiados de Circuito",
            "appCargo": "MTCCA",
            "appCargoId": 8
          },
          {
            "idTipoCandidatura": 11,
            "nombreCombo": "Juezas/es de Distrito",
            "nombreCorto": "Juezas/es de Distrito",
            "appCargo": "JUEZ DISTRITO",
            "appCargoId": 2
          }
        ]
    }.cargos[]
    |
    select(.idTipoCandidatura == $idCargo).appCargoId
;


# Get the database ID of the matter name
def get_matter_uuid($matter_name):
    {
        "matters": [
          {
            "uuid": "44ebdda1-0622-46db-9d7c-14fee2cad40c",
            "name": "N/D"
          },
          {
            "uuid": "bd829a6a-9219-47f3-ae12-06be7be407b9",
            "name": "CIVIL"
          },
          {
            "uuid": "5d262a6f-1a5c-4964-b086-b271f0302e66",
            "name": "DISCIPLINARIO"
          },
          {
            "uuid": "cc1d47c3-f547-47f5-9bf4-e9058e50c825",
            "name": "FAMILIAR"
          },
          {
            "uuid": "586dec54-1bce-4fd9-a1ac-2a65013362c4",
            "name": "LABORAL"
          },
          {
            "uuid": "118f6595-7be3-4c26-85a5-c94c681ab5eb",
            "name": "MENOR"
          },
          {
            "uuid": "232951c0-2afd-48ae-a19a-1407a0831567",
            "name": "MIXTO"
          },
          {
            "uuid": "4dccab04-adc2-4f75-a0c2-48fc5fedf332",
            "name": "PENAL"
          },
          {
            "uuid": "86674281-395d-4f5c-94a5-403ac80da52a",
            "name": "ADMINISTRATIVA"
          },
          {
            "uuid": "73bf69cf-98d6-497d-9f01-397731424892",
            "name": "ADMINISTRATIVA ESPECIALIZADO EN COMPETENCIA ECONÓMICA, RADIODIFUSIÓN Y TELECOMUNICACIONES"
          },
          {
            "uuid": "730c92ae-9feb-4131-89ac-a5359a8c42a0",
            "name": "ADMINISTRATIVA Y CIVIL"
          },
          {
            "uuid": "973c2829-8030-47b4-a7d7-c5c7c025914f",
            "name": "ADMINISTRATIVO Y DE TRABAJO"
          },
          {
            "uuid": "32c49f08-6b2a-499a-a6bf-e921823a26d8",
            "name": "APELACIÓN EN MATS. CIVIL Y ADMVA. ESPECIALIZADO EN COMPETENCIA ECONÓMICA, RADIODIFUSIÓN Y TELECOMUNICACIONES"
          },
          {
            "uuid": "b0730a9e-27fb-4631-a97c-f1cbc3b9db69",
            "name": "CIVIL Y DE TRABAJO"
          },
          {
            "uuid": "bd2d09f8-c0a1-481b-baea-58328d7dd123",
            "name": "PENAL ADMINISTRATIVO"
          },
          {
            "uuid": "5622d9b6-cd7a-43d6-a3f7-497779704543",
            "name": "PENAL Y CIVIL"
          },
          {
            "uuid": "a2a1ab1c-c3cc-4b60-8d4e-61c5d25675d2",
            "name": "PENAL Y DE TRABAJO"
          },
          {
            "uuid": "0695c75e-83f5-43ed-b74f-96982c1e9d78",
            "name": "TRABAJO"
          },
          {
            "uuid": "eab19911-36c5-4607-a564-2f9663910328",
            "name": "PENAL Y AMPARO EN MATERIA PENAL"
          },
          {
            "uuid": "1d14c94e-8ae6-47f1-b4ef-7a227eaa4dbc",
            "name": "AMPARO CIVIL, ADMINISTRATIVA Y DE TRABAJO Y JUICIOS FEDERALES"
          },
          {
            "uuid": "1cdb11b5-3f10-4ea6-a69b-bb3fcf856ed0",
            "name": "MERCANTIL"
          },
          {
            "uuid": "4b829a90-29d3-41f0-b04b-1d71788f0e44",
            "name": "ADMINISTRATIVA Y DEL TRABAJO"
          },
          {
            "uuid": "50e1cafc-2810-4b0f-afae-38bdf439bbad",
            "name": "AMPARO Y JUICIOS FEDERALES"
          }
        ]
    }.matters[]
    |
    select(.name[:-1] == ($matter_name| rtrimstr("."))[:-1]).uuid
;


# Convert sex to the postgresql enum
def get_sexo($sex_initial):
    if $sex_initial == "H" then
        "HOMBRE"
    else 
        "MUJER"
    end
;

# Get the age from the birthdate
# NOTA: otra inconsistencia de datos, los objetos de ministros scjn
# no traen fechaNacimiento
def get_age($birthDate):
    (now | strftime("%Y") | tonumber ) as $now_year |
    if $birthDate == null then
        0
    else
        ($birthDate | tostring) | split("-") 
        |
        if .[0] != null then
            $now_year - (.[0] | tonumber)
        else
            0
        end
    end
;
