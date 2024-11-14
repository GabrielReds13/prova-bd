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
	nome_fun varchar(300) not null,
    cpf_fun varchar(50) not null,
    email_fun varchar(100) not null,
    rg_fun varchar(20) not null,
    data_nasc_fun date not null,
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

# == Produto ==
delimiter $$ 
create procedure cadastrarProduto(descricaoProd varchar(300), valorProd float)
begin
	if(descricaoProd is not null) then
		if(valorProd is not null) then
			if(valorProd <= 0 or valorProd >= 1000) then
				select "O valor do produto não pode ser maior que R$ 1000,00 ou menor que R$ 0,00" as confirmacao;
			else 
				insert into Produto values (null, descricaoProd, valorProd);
                select "Produto cadastrado." as Mensagem;
            end if;
		else
			select "Valor produto é inválido" as confimacao;
        end if;	
	else 
		select "Descrição do produto é inválida" as confirmacao;
    end if;
end;
$$ delimiter ;

delimiter $$ 
create procedure consultarProduto(produto varchar(300))
begin
	declare findProduto int;
	set findProduto = (select id_pro from Produto where(descricao_pro = produto));
    
    if(produto is not null) then
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
	else
		select "Texto inválido." as Mensagem; 
    end if;
end;
$$ delimiter ;

# == Estoque ==
delimiter $$ 
create procedure cadastrarEstoque(unidade varchar(300), quantidade float, produto varchar(300))
begin
	declare findProduto int;
	
	if(unidade is not null) then
		if(quantidade is not null) then
			if(produto is not null) then
				set findProduto = (select id_pro from Produto where(descricao_pro = produto));
                
                if(findProduto) then
					insert into Estoque values (null, unidade, quantidade, findProduto);
                    select "Estoque cadastrado." as Mensagem;
                else 
					select "Produto não encontrado." as Mensagem;
                end if;
            else
				select "Valor inválido." as Mensagem;
            end if;
        else
			select "Valor inválido." as Mensagem;
        end if;
	else 
		select "Valor inválido." as Mensagem;
    end if;
end;
$$ delimiter ;

delimiter $$ 
create procedure editarEstoque(unidade varchar(300), quantidade float, produto varchar(300))
begin
	declare findProduto int;
    
	if(quantidade is not null) then
		if(produto is not null) then
			set findProduto = (select id_pro from Produto where(descricao_pro = produto));
			
			if(findProduto) then
				if(unidade is null) then
					set unidade = (select unidade_est from Estoque where(id_pro_fk = findProd));
				end if;
                
				update Estoque set unidade_est = unidade where(id_pro_fk = findProd);
				update Estoque set quantidade_est = quantidade where(id_pro_fk = findProd);
				select "Estoque editado." as Mensagem;
			else 
				select "Produto não encontrado." as Mensagem;
			end if;
		else
			select "Valor inválido." as Mensagem;
		end if;
	else
		select "Valor inválido." as Mensagem;
	end if;
end;
$$ delimiter ;

# == Cliente ==
delimiter $$ 
create procedure cadastrarCliente(nomeCli varchar(300), cpfCli varchar(30), emailCli varchar(100), rgCli varchar(30), dataNasCli date)
begin
	if(nomeCli is not null) then
		if(cpfCli is not null) then
			if(emailCli is not null) then
				if(rgCli is not null) then
					if(dataNasCli is not null) then
						insert into Cliente values (null, nomeCli, cpfCli, emailCli, rgCli, dataNasCli);
                        select "Cliente cadastrado." as Mensagem;
					else 
						select "A Data de Nascimento informada é inválida!" as confimacao;
					end if;
				else
					select "O RG informado é inválido!" as confimacao;
				end if;	
			else 
				select "O Email informado é inválido!" as confimacao;
            end if;
		else
			select "O CPF informado é inválido!" as confimacao;
        end if;	
	else 
		select "O Nome informado é inválido!" as confirmacao;
    end if;
end;
$$ delimiter ;

delimiter $$ 
create procedure consultarCliente(nome varchar(300))
begin
	declare findCliente int;
    set findCliente = (select id_cli from cliente where (nome_cli = nome));
    
    if(nome is not null) then
		set findCliente = (select id_cli from cliente where (nome_cli = nome));
    
		if(findCliente) then
			select
			nome_cli as Nome
			from Cliente;
		else
			select "Cliente não encontrado" as Mensagem; 
		end if;
    else
		select "Texto inválido." as Mensagem; 
    end if;
end;
$$ delimiter ;

# == Funcionario ==
delimiter $$ 
create procedure consultarFuncionario(nome varchar(300))
begin
	declare findFuncionario int;
	if(nome is not null) then
		set findFuncionario = (select id_fun from Funcionario where (nome_fun = nome));
    
		if(findFuncionario) then
			select
			nome_fun as Nome
			from Funcionario;
		else
			select "Funcionário não encontrado" as Mensagem; 
		end if;
    else
		select "Texto inválido." as Mensagem; 
    end if;
end;
$$ delimiter ;

<<<<<<< HEAD


#################
call cadastrarProduto("Camiseta Spiderverse", 50.00);
call cadastrarProduto("Moletom Spiderverse", 70.00);
call cadastrarProduto("Jaqueta Spiderverse", 100.00);
select * from Produto;

call cadastrarCliente("Kauan Marques", "123.456.789-00", "kauanmarques@gmail.com", "1234567", "2006-08-23");
call cadastrarCliente("Miguel Henrique", "098.765.432-1", "miguelito@gmail.com", "7654321", "2007-04-20");
call cadastrarCliente("Gabrieel Guedes", "135.791.357-99", "reds13@gmail.com", "1110202", "2006-07-18");
select * from Cliente;
=======
# == Cadastrar Cliente ==
delimiter $$ 
create procedure cadastrosCliente(nomeCli varchar(300), cpfCli varchar(30), emailCli varchar(100), rgCli varchar(30), dataNasCli date)
begin
	declare name varchar(100);
	select nome_cli into name from cliente;
	if (name<> nomeCli) then
		if(nomeCli is not null) then
			if(cpfCli is not null) then
				if(emailCli is not null) then
					if(rgCli is not null) then
						if(dataNasCli is not null) then
							insert into Cliente values (null, nomeCli, cpfCli, emailCli, rgCli, dataNasCli);
						else 
							select "A Data de Nascimento informada é inválida!" as confimacao;
						end if;
					else
						select "O RG informado é inválido!" as confimacao;
					end if;	
				else 
					select "O Email informado é inválido!" as confimacao;
				end if;
			else
				select "O CPF informado é inválido!" as confimacao;
			end if;	
		else 
			select "O Nome informado é inválido!" as confirmacao;
		end if;
	else 
		select "O Nome informado já existe!" as confirmacao;
	end if;
end;
$$ delimiter ;

call cadastrosCliente("Kauan Marques", "123.456.789-00", "kauanmarques@gmail.com", "1234567", "2006-08-23");
call cadastrosCliente("Miguel Henrique", "098.765.432-1", "miguelito@gmail.com", "7654321", "2007-04-20");
call cadastrosCliente("Gabrieel Guedes", "135.791.357-99", "reds13@gmail.com", "1110202", "2006-07-18");

# == Cadastrar Usuário ==
delimiter $$ 
create procedure cadUsuarios(nomeUsu varchar(300), cpfUsu varchar(30), emailUsu varchar(100), rgUsu varchar(30), dataNasUsu date)
begin
	declare nameUsu varchar(100);
	select count(*) into nameUsu from Usuario where nomeUsu = nome_usu;
	if (nameUsu > 0) then
		select "O Nome informado já existe!" as confirmacao;
    else 
		if(nomeUsu is not null) then
			if(cpfUsu is not null) then
				if(emailUsu is not null) then
					if(rgUsu is not null) then
						if(dataNasUsu is not null) then
							insert into Usuario values (null, nomeUsu, cpfUsu, emailUsu, rgUsu, dataNasUsu);
						else 
							select "A Data de Nascimento informada é inválida!" as confimacao;
						end if;
					else
						select "O RG informado é inválido!" as confimacao;
					end if;	
				else 
					select "O Email informado é inválido!" as confimacao;
				end if;
			else
				select "O CPF informado é inválido!" as confimacao;
			end if;	
		else 
			select "O Nome informado é inválido!" as confirmacao;
		end if;
	end if;
		
end;
$$ delimiter ;

call cadUsuarios("João Santos", "123.456.789-00", "santsj@gmail.com", "1234567", "2006-08-23");
call cadastroUsuario("Matheus Silva", "098.765.432-1", "matheuss@gmail.com", "7654321", "2007-04-20");
call cadastroUsuario("Gabriel gomes", "135.791.357-99", "rgomes@gmail.com", "1110202", "2006-07-18");
select * from venda;



<<<<<<< HEAD
#$$ delimiter ;
>>>>>>> origin/master
=======
insert into venda values (null, 200, '2024-11-12', '12:00:00', 1);
# == Forma Pagamento == 
delimiter $$
create procedure formPagament(formaPag varchar(30), idVenda int)
begin

	declare idvend int;
    
	select (venda.id_ven) into idvend from venda where idVenda = id_ven;

	if(idVenda is not null) then
		if (formaPag is not null) then 
			insert into forma_pagamento values (null, formaPag, idVenda);
		else
			select "A forma de pagamento está incorreta!" as confirmacao;
		end if;
	else
		select "A chave estrangeira informada está incorreta!" as confirmacao;
	end if;
end;
$$ delimiter ;

call formPagament("Pix", 3);

select * from forma_pagamento;
>>>>>>> origin/master

