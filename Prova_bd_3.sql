create database Prova_BD_3;
use Prova_BD_3;

# === Livres ===
create table Produto(
	id_pro int primary key auto_increment,
    descricao_pro varchar(300) not null,
    valor_pro float not null
);

# === Semi-Livres ===
create table Funcionario(
	id_fun int primary key auto_increment,
	nome_usu varchar(300) not null,
    cpf_usu varchar(50) not null,
    email_usu varchar(100) not null,
    rg_usu varchar(20) not null,
    data_nasc_usu date not null,
    salario_fun float not null
);

create table Cliente(
	id_cli int primary key auto_increment,
	nome_cli varchar(300) not null,
    cpf_cli varchar(50) not null,
    email_cli varchar(100) not null,
    rg_cli varchar(20) not null,
    data_nasc_cli date not null
);

create table Usuario(
	id_usu int primary key auto_increment,
	nome_usu varchar(300) not null,
    cpf_usu varchar(50) not null,
    email_usu varchar(100) not null,
    rg_usu varchar(20) not null,
    data_nasc_usu date not null
);

create table Venda(
	id_ven int primary key auto_increment,
    valor_total_ven float not null,
    data_ven date not null,
    hora_ven time not null,
    
    id_pro_fk int,
    foreign key(id_pro_fk) references Produto(id_pro)
);

# === Presas ===
create table Estoque(
	id_est int primary key auto_increment,
    unidade_est varchar(100) not null,
	quantidade_est int not null,
    
    id_pro_fk int,
    foreign key(id_pro_fk) references Produto(id_pro)
);

create table Forma_Pagamento(
	id_fpag int primary key auto_increment,
    forma_fpag varchar(200) not null,
    
    id_ven_fk int,
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table FunVen(
	id_funven int primary key auto_increment,
    
    id_fun_fk int,
    id_ven_fk int,
    foreign key(id_fun_fk) references Funcionario(id_fun),
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table CliVen(
	id_cliven int primary key auto_increment,
    
    id_ven_fk int,
    foreign key(id_ven_fk) references Venda(id_ven)
);

create table UseVen(
	id_useven int primary key auto_increment,
    
    id_usu_fk int,
    id_ven_fk int,
    foreign key(id_usu_fk) references Usuario(id_usu),
    foreign key(id_ven_fk) references Venda(id_ven)
);

# === Metodos ===
<<<<<<< HEAD


# == Cadastrar Produto ==
delimiter $$ 
create procedure cadastroProduto(descricaoProd varchar(300), valorProd float)
begin
	if(descricaoProd is not null) then
		if(valorProd is not null) then
			if(valorProd <= 0 or valorProd >= 1000) then
				select "O valor do produto não pode ser maior que R$ 1000,00 ou menor que R$ 0,00" as confirmacao;
			else 
				insert into Produto values (null, descricaoProd, valorProd);
            end if;
		else
			select "Valor produto é inválido" as confimacao;
        end if;	
	else 
		select "Descrição do produto é inválida" as confirmacao;
    end if;
end;
$$ delimiter ;

call cadastroProduto("", 590);

select * from produto;
=======
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

>>>>>>> bf4749ebd08ea41b94b67067d757d74ee6986a5e
