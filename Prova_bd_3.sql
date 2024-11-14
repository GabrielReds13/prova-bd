/* 
Alunos:

Gabriel Guedes
Kauan Marques
Miguel Henrique

*/

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
    desconto_vend int not null,
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

call cadastrarProduto("Camiseta Spiderverse", 50.00);
call cadastrarProduto("Moletom Spiderverse", 70.00);
call cadastrarProduto("Jaqueta Spiderverse", 100.00);

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

call cadastrarEstoque("2", 50, "Vara de pesca");
call cadastrarEstoque("3", 100, "Vara de pesca boa");
call cadastrarEstoque("4", 175, "Vara de pesca muito boa");

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

call cadastrarCliente("Kauan Marques", "123.456.789-00", "kauanmarques@gmail.com", "1234567", "2006-08-23");
call cadastrarCliente("Miguel Henrique", "098.765.432-1", "miguelito@gmail.com", "7654321", "2007-04-20");
call cadastrarCliente("Gabrieel Guedes", "135.791.357-99", "reds13@gmail.com", "1110202", "2006-07-18");

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
create procedure cadastroFuncionario(nome_fun varchar(300), cpf_fun varchar(100), email_fun varchar(100), rg_fun varchar(100), data_nasc_fun date, salario_fun float)
begin
    if(nome_fun is not null) then
        if(cpf_fun is not null) then
            if(email_fun is not null) then
                if(rg_fun is not null) then
                    if(data_nasc_fun is not null) then
                        if(salario_fun is not null) then
                            insert into funcionario values (null, nome_fun, cpf_fun, email_fun, rg_fun, data_nasc_fun, salario_fun);
                        else select "Salário inválido" as confirmacao;
                        end if;
                    else select "Data de nascimento inválida" as confirmacao;
                    end if;
                else select "RG inválido" as confirmacao;
                end if;
            else select "Email inválido" as confirmacao;
            end if;
        else select "CPF inválido" as confirmacao;
        end if;
    else select "Nome inválido" as confirmacao;
    end if;
end;
$$ delimiter ;

call cadastroFuncionario("Adriel", "102.390.192-32", "adriel@gmail.com", "123123", "2001-02-03", 3000);
call cadastroFuncionario("Kauan", "422.190.195-62", "kauan@gmail.com", "567323", "2000-05-07", 3000);
call cadastroFuncionario("Guedes", "167.324.167-39", "Guedes@gmail.com", "124423", "2002-03-04", 3000);

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

# == Usuário ==
delimiter $$ 
create procedure cadastrarUsuario(nomeUsu varchar(300), cpfUsu varchar(30), emailUsu varchar(100), rgUsu varchar(30), dataNasUsu date)
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

call cadastrarUsuario("João Santos", "123.456.789-00", "santsj@gmail.com", "1234567", "2006-08-23");
call cadastrarUsuario("Matheus Silva", "098.765.432-1", "matheuss@gmail.com", "7654321", "2007-04-20");
call cadastrarUsuario("Gabriel gomes", "135.791.357-99", "rgomes@gmail.com", "1110202", "2006-07-18");

# == Venda ==

delimiter $$
create procedure registrarVenda(valorTotal float, dataVend date, horaVend time, descontoVend int, idProd int)
begin 
    declare idPro int;

    select id_pro into idPro from Produto where id_pro = idProd;
    
    if idPro is not null then
        if valorTotal is not null and dataVend is not null and horaVend is not null and descontoVend is not null then
            if descontoVend < 10 and horaVend between '08:00:00' and '18:00:00' then
                insert into Venda (valor_total_ven, data_ven, hora_ven, desconto_vend, id_pro_fk) values (valorTotal, dataVend, horaVend, descontoVend, idPro);
                select "Venda registrada com sucesso." as Mensagem;
            else 
                select "Desconto ou horário de venda não permitido." as Mensagem;
            end if;
        else
            select "Valores de venda incompletos." as Mensagem;
        end if;
    else 
        select "Produto não encontrado." as Mensagem;
    end if;
end;
$$
delimiter ;

call registrarVenda (200, '2024-11-13', '17:00:02', 8, 1);
call registrarVenda (400, '2024-11-14', '17:00:04', 5, 1);
call registrarVenda (600, '2024-11-15', '17:00:06', 9, 1);

# == Forma Pagamento == 
delimiter $$
create procedure formaPagamento(formaPag varchar(30), vendaId int)
begin
    declare idvend int;

    select id_ven into idvend from Venda where id_ven = vendaId;

    if idvend is not null then
        if formaPag is not null then
            insert into Forma_Pagamento (forma_fpag, id_ven_fk) values (formaPag, vendaId);
            select "Forma de pagamento cadastrada com sucesso." as Mensagem;
        else
            select "Forma de pagamento inválida." as Mensagem;
        end if;
    else
        select "Venda não encontrada." as Mensagem;
    end if;
end;
$$
delimiter ;

call formaPagamento("Pix", 1);
call formaPagamento("Crédito", 1);
call formaPagamento("Débito", 1);