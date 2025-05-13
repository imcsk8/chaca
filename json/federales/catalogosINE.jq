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

# Returns the database ID of the proponent power
def get_poder($id_poder):
    # appPoderId is a quick and dirty hack that has the current database
    # cat_poderes uuid, this is going to be different because the migrations create
    # random uuids (maybe leave this fixed in the migration?)
    {
      "fecha": "Mon May 12 00:00:06 GMT-06:00 2025",
      "poderesUnion": [
        {
          "siglas": "PEF",
          "nombre": "Poder Ejecutivo Federal",
          "idPoderUnion": 1,
          "appPoderId": "7c29d650-0bb8-4412-8b09-d74e20bd3052"
        },
        {
          "siglas": "PLF",
          "nombre": "Poder Legislativo Federal",
          "idPoderUnion": 2,
          "appPoderId": "e5fa9cae-06f4-4c37-904e-511924019ece"
        },
        {
          "siglas": "PJF",
          "nombre": "Poder Judicial de la Federación",
          "idPoderUnion": 3,
          "appPoderId": "c7ef7124-0ff3-4084-8d6d-cd246ebb0d6c"
        },
        {
          "siglas": "EF",
          "nombre": "En Funciones",
          "idPoderUnion": 4,
          "appPoderId": "f4a69bea-1806-475f-b5a4-6bb0c927c449"
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
        null
    else
        ($birthDate | tostring) | split("-") 
        |
        if .[0] != null then
            $now_year - (.[0] | tonumber)
        else
            null
        end
    end
;
