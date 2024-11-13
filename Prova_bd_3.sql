create database Prova_BD_3;
use Prova_BD_3;

# === Livres ===
create table Credencial(
	id_cre int primary key not null,
    nome_cre varchar(300) not null,
    cpf_cre varchar(14) not null,
    data_nasc_cre date,
    telefone_cre varchar(11)
);

create table Produto(
	id_pro int primary key not null,
    descricao_pro varchar(300),
    valor_pro float
);

# === Semi-Livres ===
create table Funcionario(
	id_fun int primary key not null,
    salario_fun float not null,
	
    id_cre_fk int,
    foreign key(id_cre_fk) references Credencial(id_cre)
);

create table Cliente(
	id_cli int primary key not null,
	
    id_cre_fk int,
    foreign key(id_cre_fk) references Credencial(id_cre)
);

create table Usuario(
	id_usu int primary key not null,
	
    id_cre_fk int,
    foreign key(id_cre_fk) references Credencial(id_cre)
);

create table Venda(
	id_ven int primary key not null,
    valor_total_ven float,
    data_ven date not null,
    hora_ven time not null,
    
    id_pro_fk int,
    foreign key(id_pro_fk) references Produto(id_pro)
);

# === Presas ===
create table Estoque(
	id_est int primary key not null,
    unidade_est varchar(100) not null,
	quantidade_est int,
    
    id_pro_fk int,
    foreign key(id_pro_fk) references Produto(id_pro)
);

create table Forma_Pagamento(
	id_fpag int primary key not null,
    forma_fpag varchar(200),
    
    id_ven_fk int,
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table FunVen(
	id_funven int primary key not null,
    
    id_fun_fk int,
    id_ven_fk int,
    foreign key(id_fun_fk) references Funcionario(id_fun),
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table CliVen(
	id_cliven int primary key not null,
    
    id_cli_fk int,
    id_ven_fk int,
    foreign key(id_cli_fk) references Cliente(id_cli),
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table UseVen(
	id_useven int primary key not null,
    
    id_usu_fk int,
    id_ven_fk int,
    foreign key(id_usu_fk) references Usuario(id_usu),
    foreign key(id_ven_fk) references Venda(id_ven)
);

# === Metodos ===
delimiter $$ 
create procedure consultarProduto(produto varchar(300))
begin
	declare findProduto int;
	set findProduto = (select id_pro from Produto where(descricao_pro = produto));
    
    if(findProduto) then
		select 
		Produto.descricao_pro as Produto, 
        Estoque.unidade_est as Unidade,
        Estoque.quantidade_est as Quantiade,
		Produto.valor_pro as Valor 
        from Produto
        inner join Estoque on (id_pro_fk = findProduto);
	else
		select "Item não encontrado" as Mensagem;
    end if;
end;
$$ delimiter ;

