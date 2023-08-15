IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [tb_categoria_produto] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(50) NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_categoria_produto] PRIMARY KEY ([id])
);
GO

CREATE TABLE [tb_cidade] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(100) NOT NULL,
    [uf] nvarchar(2) NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_cidade] PRIMARY KEY ([id])
);
GO

CREATE TABLE [tb_imagem] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(20) NOT NULL,
    [nome_arquivo] nvarchar(20) NOT NULL,
    [principal] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_imagem] PRIMARY KEY ([id])
);
GO

CREATE TABLE [tb_produto] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(50) NOT NULL,
    [codigo] nvarchar(50) NOT NULL,
    [descricao] nvarchar(50) NOT NULL,
    [preco] decimal(17,2) NOT NULL,
    [id_categoria] int NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_produto] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_produto_tb_categoria_produto_id_categoria] FOREIGN KEY ([id_categoria]) REFERENCES [tb_categoria_produto] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_endereco] (
    [id] int NOT NULL IDENTITY,
    [tipo] tinyint NOT NULL,
    [logradouro] nvarchar(50) NOT NULL,
    [bairro] nvarchar(50) NOT NULL,
    [numero] nvarchar(10) NOT NULL,
    [complemento] nvarchar(50) NOT NULL,
    [cep] nvarchar(8) NOT NULL,
    [id_cidade] int NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_endereco] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_endereco_tb_cidade_id_cidade] FOREIGN KEY ([id_cidade]) REFERENCES [tb_cidade] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_combo] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(50) NOT NULL,
    [preco] decimal(17,2) NOT NULL,
    [id_imagem] int NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_combo] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_combo_tb_imagem_id_imagem] FOREIGN KEY ([id_imagem]) REFERENCES [tb_imagem] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_imagem_produto] (
    [id_imagem] int NOT NULL,
    [id_produto] int NOT NULL,
    CONSTRAINT [PK_tb_imagem_produto] PRIMARY KEY ([id_imagem], [id_produto]),
    CONSTRAINT [FK_tb_imagem_produto_tb_imagem_id_imagem] FOREIGN KEY ([id_imagem]) REFERENCES [tb_imagem] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_tb_imagem_produto_tb_produto_id_produto] FOREIGN KEY ([id_produto]) REFERENCES [tb_produto] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_promocao_produto] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(50) NOT NULL,
    [preco] decimal(17,2) NOT NULL,
    [id_imagem] int NOT NULL,
    [id_produto] int NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_promocao_produto] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_promocao_produto_tb_imagem_id_imagem] FOREIGN KEY ([id_imagem]) REFERENCES [tb_imagem] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_tb_promocao_produto_tb_produto_id_produto] FOREIGN KEY ([id_produto]) REFERENCES [tb_produto] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_cliente] (
    [id] int NOT NULL IDENTITY,
    [nome] nvarchar(100) NOT NULL,
    [cpf] nvarchar(11) NOT NULL,
    [id_endereco] int NOT NULL,
    [ativo] bit NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_cliente] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_cliente_tb_endereco_id_endereco] FOREIGN KEY ([id_endereco]) REFERENCES [tb_endereco] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_produto_combo] (
    [id_produto] int NOT NULL,
    [id_combo] int NOT NULL,
    CONSTRAINT [PK_tb_produto_combo] PRIMARY KEY ([id_produto], [id_combo]),
    CONSTRAINT [FK_tb_produto_combo_tb_combo_id_combo] FOREIGN KEY ([id_combo]) REFERENCES [tb_combo] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_tb_produto_combo_tb_produto_id_produto] FOREIGN KEY ([id_produto]) REFERENCES [tb_produto] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_pedido] (
    [id] int NOT NULL IDENTITY,
    [numero] nvarchar(10) NOT NULL,
    [valor_total] decimal(17,2) NOT NULL,
    [entrega] time NOT NULL,
    [id_cliente] int NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_pedido] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_pedido_tb_cliente_id_cliente] FOREIGN KEY ([id_cliente]) REFERENCES [tb_cliente] ([id]) ON DELETE CASCADE
);
GO

CREATE TABLE [tb_produto_pedido] (
    [id] int NOT NULL IDENTITY,
    [quantidade] int NOT NULL,
    [preco] decimal(17,2) NOT NULL,
    [id_produto] int NOT NULL,
    [id_pedido] int NOT NULL,
    [criado_em] datetime2 NOT NULL,
    CONSTRAINT [PK_tb_produto_pedido] PRIMARY KEY ([id]),
    CONSTRAINT [FK_tb_produto_pedido_tb_pedido_id_pedido] FOREIGN KEY ([id_pedido]) REFERENCES [tb_pedido] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_tb_produto_pedido_tb_produto_id_produto] FOREIGN KEY ([id_produto]) REFERENCES [tb_produto] ([id]) ON DELETE CASCADE
);
GO

CREATE UNIQUE INDEX [IX_tb_cliente_id_endereco] ON [tb_cliente] ([id_endereco]);
GO

CREATE INDEX [IX_tb_combo_id_imagem] ON [tb_combo] ([id_imagem]);
GO

CREATE INDEX [IX_tb_endereco_id_cidade] ON [tb_endereco] ([id_cidade]);
GO

CREATE INDEX [IX_tb_imagem_produto_id_produto] ON [tb_imagem_produto] ([id_produto]);
GO

CREATE INDEX [IX_tb_pedido_id_cliente] ON [tb_pedido] ([id_cliente]);
GO

CREATE INDEX [IX_tb_produto_id_categoria] ON [tb_produto] ([id_categoria]);
GO

CREATE INDEX [IX_tb_produto_combo_id_combo] ON [tb_produto_combo] ([id_combo]);
GO

CREATE INDEX [IX_tb_produto_pedido_id_pedido] ON [tb_produto_pedido] ([id_pedido]);
GO

CREATE INDEX [IX_tb_produto_pedido_id_produto] ON [tb_produto_pedido] ([id_produto]);
GO

CREATE INDEX [IX_tb_promocao_produto_id_imagem] ON [tb_promocao_produto] ([id_imagem]);
GO

CREATE INDEX [IX_tb_promocao_produto_id_produto] ON [tb_promocao_produto] ([id_produto]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230814140746_Init', N'7.0.9');
GO

COMMIT;
GO

