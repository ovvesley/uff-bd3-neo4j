// CRIANDO PERFIS
CREATE
  (jose:Perfil {nome: 'Jose', data_nascimento: "20/05/1990", pais: "BR", cidade: "São Paulo", sexo: "M", religiao: "Ateu", estado_civil: "Casado"}),
  (mauro:Perfil {nome: 'Mauro', data_nascimento: "15/11/1985", pais: "BR", cidade: "Belo Horizonte", sexo: "M", religiao: "Católico", estado_civil: "Solteiro"}),
  (leda:Perfil {nome: 'Leda', data_nascimento: "03/03/1995", pais: "BR", cidade: "Porto Alegre", sexo: "F", religiao: "Espírita", estado_civil: "Casada"}),
  (erika:Perfil {nome: 'Erika', data_nascimento: "12/09/1998", pais: "BR", cidade: "Curitiba", sexo: "F", religiao: "Agnóstica", estado_civil: "Solteira"}),
  (daniel:Perfil {nome: 'Daniel', data_nascimento: "28/07/2000", pais: "BR", cidade: "Fortaleza", sexo: "M", religiao: "Protestante", estado_civil: "Casado"}),
  (edilson:Perfil {nome: 'Edilson', data_nascimento: "05/12/1992", pais: "BR", cidade: "Recife", sexo: "M", religiao: "Hinduísta", estado_civil: "Solteiro"}),
  (aline:Perfil {nome: 'Aline', data_nascimento: "10/02/1994", pais: "BR", cidade: "Salvador", sexo: "F", religiao: "Budista", estado_civil: "Solteira"});

// CRIANDO AMIZADES
MATCH (mauro:Perfil {nome: 'Mauro'})
MATCH (leda:Perfil {nome: 'Leda'})
MATCH (erika:Perfil {nome: 'Erika'})
MATCH (daniel:Perfil {nome: 'Daniel'})
MATCH (edilson:Perfil {nome: 'Edilson'})
MATCH (aline:Perfil {nome: 'Aline'})
MATCH (jose:Perfil {nome: 'Jose'})
CREATE (mauro)-[:AMIGO]->(leda),
       (mauro)-[:AMIGO]->(erika),
       (mauro)-[:AMIGO]->(daniel),
       (mauro)-[:AMIGO]->(edilson),
       (mauro)-[:AMIGO]->(aline),
       (leda)-[:AMIGO]->(mauro),
       (leda)-[:AMIGO]->(erika),
       (leda)-[:AMIGO]->(edilson),
       (erika)-[:AMIGO]->(mauro),
       (erika)-[:AMIGO]->(leda),
       (erika)-[:AMIGO]->(aline),
       (daniel)-[:AMIGO]->(mauro),
       (daniel)-[:AMIGO]->(edilson),
       (daniel)-[:AMIGO]->(aline),
       (edilson)-[:AMIGO]->(mauro),
       (edilson)-[:AMIGO]->(leda),
       (edilson)-[:AMIGO]->(daniel),
       (aline)-[:AMIGO]->(mauro),
       (aline)-[:AMIGO]->(erika),
       (aline)-[:AMIGO]->(daniel),
       (aline)-[:AMIGO]->(jose),
       (jose)-[:AMIGO]->(aline);


// MENSAGEM ENTRE MAURO E AMIGOS
MATCH (mauro:Perfil {nome: 'Mauro'})
MATCH (mauro)-[:AMIGO]->(amigo)
CREATE (conversa:Conversa {
  data_inicio: datetime('2023-01-01T00:00:00Z')
})
CREATE (mauro)-[:PARTICIPA_DE {mensagem: ["Bom dia, Familia!"]}]->(conversa)
CREATE (amigo)-[:PARTICIPA_DE {mensagem: ["Bom dia, Mauro!"]}]->(conversa)

// POSTAGEM DE MAURO
MATCH (mauro:Perfil {nome: 'Mauro'})
CREATE (postagem:Postagem {
  data: datetime('2023-01-01T00:00:00Z'),
  texto: "Cortei o cabelo, galera! O que acharam?",
  imagem: "https://upload.wikimedia.org/wikipedia/en/thumb/6/6a/Mike_Wazowski.png/220px-Mike_Wazowski.png",
  type: "PHOTO"
})
CREATE (mauro)-[:POSTOU]->(postagem)

// AMIGO DE MAURO COMENTA A POSTAGEM DE MAURO
MATCH (mauro:Perfil {nome: 'Mauro'})
MATCH (mauro)-[:POSTOU]->(postagem)
MATCH (mauro)-[:AMIGO]->(amigo)

CREATE (amigo)-[:COMENTOU {comentario: ['ficou lindo mauro']}]->(postagem)

//POSTAGEM DE ALINE

MATCH (aline:Perfil {nome: 'Aline'})
CREATE (postagem:Postagem {
  data: datetime('2023-01-01T00:00:00Z'),
  texto: "A Pedra: É pau é pedra é o fim do caminho",
  imagem: null,
  type: "TEXT"
})
CREATE (aline)-[:POSTOU]->(postagem)

// AMIGOS DE ALINE COMENTAM A POSTAGEM DE ALINE
MATCH (aline:Perfil {nome: 'Aline'})
MATCH (aline)-[:POSTOU]->(postagem)
MATCH (aline)-[:AMIGO]->(amigo)

CREATE (amigo)-[:COMENTOU {comentario: ['falou tudo, miga!']}]->(postagem)

// MENSAGEM ENTRE ALINE E JOSE falando mal de Mauro
MATCH (aline:Perfil {nome: 'Aline'})
MATCH (jose:Perfil {nome: 'Jose'})

CREATE (conversa:Conversa {
  data_inicio: datetime('2023-01-02T00:00:00Z')
})

CREATE (aline)-[:PARTICIPA_DE {mensagem: ["Oi, Jose!", "Que mensagenzinha chata do mauro, todo dia isso, não aguento mais."]}]->(conversa)
CREATE (jose)-[:PARTICIPA_DE {mensagem: ["Oi, Aline!", "Pois é, ele é muito chato mesmo."]}]->(conversa)

//--------------------------------------------
// QUERIES
// --------------------------------------------

// Quais sao os amigos dos amigos de Jose?
MATCH (jose:Perfil {nome: 'Jose'})
MATCH (jose)-[:AMIGO]->(amigo_jose)
MATCH (amigo_jose)-[:AMIGO]->(amigo_do_amigo_jose)
RETURN amigo_do_amigo_jose

// Quais amigos de José comentaram a foto de Mauro?
MATCH (jose:Perfil {nome: 'Jose'})
MATCH (jose)-[:AMIGO]->(amigo_jose)
MATCH (postagem)<-[:POSTOU]-(mauro:Perfil {nome: 'Mauro'})
MATCH (amigo_jose)-[:COMENTOU]->(postagem)
RETURN amigo_jose
