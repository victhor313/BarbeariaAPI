using MySql.Data.MySqlClient;

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

// Ativa a liberação
app.UseCors();

// Sua string de conexão do MySQL
string conexaoString = "Server=127.0.0.1;Database=BarbeariaTechh;Uid=root;Pwd=58935832Vv.;Port=3306;";

// ROTA DE TESTE
app.MapGet("/", () => "Servidor da Barbearia funcionando! 🚀");

// ROTA DE CADASTRO: A rota que vai receber os dados do HTML
app.MapPost("/api/cadastrar", (Cliente novoCliente) =>
{
    using (MySqlConnection conn = new MySqlConnection(conexaoString))
    {
        try
        {
            conn.Open();

            // Query para salvar na sua tabela 'usuarios'
            string query = "INSERT INTO usuarios (nome, cpf, telefone, email) VALUES (@nome, @cpf, @telefone, @email)";

            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@nome", novoCliente.Nome);
                cmd.Parameters.AddWithValue("@cpf", novoCliente.Cpf);
                cmd.Parameters.AddWithValue("@telefone", novoCliente.Telefone);
                cmd.Parameters.AddWithValue("@email", novoCliente.Email);

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

app.Run();

// Molde para o C# receber as informações organizadas
public record Cliente(string Nome, string Cpf, string Telefone, string Email)
