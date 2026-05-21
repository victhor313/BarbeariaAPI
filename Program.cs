using System.Text.Json.Serialization;
using MySql.Data.MySqlClient; // 1. Garante a importação correta do MySQL

var builder = WebApplication.CreateBuilder(args);

// Libera o acesso para que o HTML 
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();
app.UseCors();

string conexaoString = "Server=127.0.0.1;Database=BarbeariaTechh;Uid=root;Pwd=58935832Vv.;Port=3306;";

app.MapGet("/", () => "Servidor da Barbearia funcionando! 🚀");

// ROTA DE CADASTRO CORRIGIDA
app.MapPost("/api/cadastrar", (Cliente novoCliente) =>
{
    using (MySqlConnection conn = new MySqlConnection(conexaoString))
    {
        try
        {
            conn.Open();

            string queryVerificacao = @"SELECT COUNT(*) FROM clientes 
                                      WHERE telefone = @telefone 
                                      OR email = @email
                                      OR (nome = @nome AND telefone = @telefone)";

            using (MySqlCommand cmdVerifica = new MySqlCommand(queryVerificacao, conn))
            {
                cmdVerifica.Parameters.AddWithValue("@nome", novoCliente.Nome);
                cmdVerifica.Parameters.AddWithValue("@telefone", novoCliente.Telefone);
                cmdVerifica.Parameters.AddWithValue("@email", novoCliente.Email);

                long clienteExiste = (long)cmdVerifica.ExecuteScalar();
                if (clienteExiste > 0)
                {
                    return Results.BadRequest(new { erro = "Regra de Negócio: Já existe um cliente cadastrado com este Nome, E-mail ou Telefone!" });
                }
            }

            // Query de inserção ajustada para a tabela 'clientes' e incluindo a senha
            string query = "INSERT INTO clientes (nome, cpf, telefone, email, senha) VALUES (@nome, @cpf, @telefone, @email, @senha)";

            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@nome", novoCliente.Nome);
                cmd.Parameters.AddWithValue("@cpf", novoCliente.Cpf);
                cmd.Parameters.AddWithValue("@telefone", novoCliente.Telefone);
                cmd.Parameters.AddWithValue("@email", novoCliente.Email);
                cmd.Parameters.AddWithValue("@senha", novoCliente.Senha); // Mapeado corretamente agora

                cmd.ExecuteNonQuery();
            }

            return Results.Ok(new { mensagem = $"Sucesso! {novoCliente.Nome} foi cadastrado." });
        }
        catch (Exception ex)
        {
            return Results.BadRequest(new { erro = "Erro no banco de dados: " + ex.Message });
        }
    }
});

// NOVA ROTA DE LOGIN SEGUINDO A MESMA ESTRUTURA
app.MapPost("/api/login", (LoginCliente dadosLogin) =>
{
    using (MySqlConnection conn = new MySqlConnection(conexaoString))
    {
        try
        {
            conn.Open();

            string queryLogin = @"SELECT id_cliente, nome, telefone, email 
                                  FROM clientes 
                                  WHERE (email = @usuario OR telefone = @usuario) 
                                  AND senha = @senha";

            using (MySqlCommand cmd = new MySqlCommand(queryLogin, conn))
            {
                cmd.Parameters.AddWithValue("@usuario", dadosLogin.Usuario);
                cmd.Parameters.AddWithValue("@senha", dadosLogin.Senha);

                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return Results.Ok(new
                        {
                            Nome = reader.GetString("nome"),
                            Email = reader.GetString("email"),
                            Mensagem = "Login efetuado com sucesso!"
                        });
                    }
                }
            }

            return Results.Json(new { erro = "Usuário (E-mail/Telefone) ou senha incorretos!" }, statusCode: 401);
        }
        catch (Exception ex)
        {
            return Results.BadRequest(new { erro = "Erro ao tentar realizar login: " + ex.Message });
        }
    }
});

app.Run("http://localhost:5151");


public record Cliente(string Nome, string Cpf, string Telefone, string Email, string Senha);
public record LoginCliente(string Usuario, string Senha);

// ==========================================
// ROTAS DE BARBEIROS
// ==========================================

// 1. ROTA DE LISTAGEM DE BARBEIROS (GET)
app.MapGet("/api/barbeiros", () =>
{
    var listaBarbeiros = new List<object>();

    using (MySqlConnection conn = new MySqlConnection(conexaoString))
    {
        try
        {
            conn.Open();
            string query = "SELECT id_barbeiro, nome, status, telefone, email, especialidade FROM barbeiros";

            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            using (MySqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaBarbeiros.Add(new
                    {
                        id_barbeiro = reader.IsDBNull(0) ? null : (int?)reader.GetInt32(0),
                        nome = reader.IsDBNull(1) ? null : reader.GetString(1),
                        status = reader.IsDBNull(2) ? null : reader.GetString(2),
                        telefone = reader.IsDBNull(3) ? null : reader.GetString(3),
                        email = reader.IsDBNull(4) ? null : reader.GetString(4),
                        especialidade = reader.IsDBNull(5) ? null : reader.GetString(5)
                    });
                }
            }
            return Results.Ok(listaBarbeiros);
        }
        catch (Exception ex)
        {
            return Results.BadRequest(new { erro = "Erro ao buscar barbeiros: " + ex.Message });
        }
    }
});

// 2. ROTA DE CADASTRO DE BARBEIROS (POST)
app.MapPost("/api/barbeiros", (Barbeiros novoFuncionario) =>
{
    using (MySqlConnection conn = new MySqlConnection(conexaoString))
    {
        try
        {
            conn.Open();

            string query = "INSERT INTO barbeiros (nome, status, telefone, email, id_barbeiro, especialidade) " +
                           "VALUES (@nome, @status, @telefone, @email, @id_barbeiro, @especialidade)";

            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@nome", (object?)novoFuncionario.Nome ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@status", (object?)novoFuncionario.Status ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@telefone", (object?)novoFuncionario.Telefone ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@email", (object?)novoFuncionario.Email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@id_barbeiro", (object?)novoFuncionario.Id_barbeiro ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@especialidade", (object?)novoFuncionario.Especialidade ?? DBNull.Value);

                cmd.ExecuteNonQuery();
            }

            return Results.Ok(new { mensagem = $"Sucesso! O barbeiro {novoFuncionario.Nome} foi cadastrado." });
        }
        catch (Exception ex)
        {
            return Results.BadRequest(new { erro = "Erro no banco de dados: " + ex.Message });
        }
    }
});

// Inicializa o servidor na porta oficial do seu projeto
app.Run();


// ==================================================================
// MODELOS E CLASSES
// ==================================================================

public record Cliente(string Nome, string Cpf, string Telefone, string Email);

public class Barbeiros
{
    [JsonPropertyName("nome")]
    public string? Nome { get; set; }

    [JsonPropertyName("status")]
    public string? Status { get; set; }

    [JsonPropertyName("telefone")]
    public string? Telefone { get; set; }

    [JsonPropertyName("email")]
    public string? Email { get; set; }

    [JsonPropertyName("id_barbeiro")]
    public int? Id_barbeiro { get; set; }

    [JsonPropertyName("especialidade")]
    public string? Especialidade { get; set; }
}
