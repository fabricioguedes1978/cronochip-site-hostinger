# Cronochip Resultados — pacote Hostinger

Versão independente para hospedagem comum com Apache, PHP 8.1+ e MySQL 8/MariaDB 10.5+.

## Publicação inicial

1. No painel da hospedagem, crie um banco MySQL e um usuário com acesso completo a ele.
2. Envie o conteúdo deste pacote preservando a estrutura: `public_html/` deve ser a pasta pública do domínio; `private/` e `sql/` devem ficar um nível acima dela.
3. Garanta permissão de escrita temporária na pasta `private/` para o PHP.
4. Abra `https://seu-endereco/install.php`, informe o banco e conclua a instalação.
5. Apague `public_html/install.php` assim que a mensagem de sucesso aparecer.
6. Abra `/health-check.html` e execute a verificação.
7. Antes da troca do DNS, use um subdomínio temporário e teste cadastro, envio de TXT, consulta pública e Telão.

## GitHub

Pode versionar este pacote sem `private/config.php` e `private/installed.lock`. Eles são criados apenas na hospedagem e contêm a configuração real.

## Endereços do serviço

- Saúde: `/api/health`
- Eventos públicos: `/api/events`
- Evento: `/api/event?slug=...`
- Busca: `/api/search?slug=...&q=...`
- Classificação: `/api/ranking?slug=...&d=...&g=M`
- Programa Windows: `/api/public/desktop/...`
- Recebimento TXT: `/api/public/ingest/{token}`

## Regras importantes

- O TXT usa ponto e vírgula (`;`).
- O arquivo é validado antes da publicação.
- A troca dos resultados ocorre em uma única transação; em falha, a versão anterior permanece.
- Arquivo idêntico não é reprocessado.
- O serviço aceita no máximo 20 MB por TXT.
- O programa Windows usa assinatura RSA e cada evento tem uma chave de envio própria.
- Não altere o DNS principal nem substitua o programa Windows até todos os testes no endereço temporário passarem.

## Pastas protegidas

`private/` deve permanecer fora da pasta pública. Nunca envie `config.php` ou senhas ao GitHub.
