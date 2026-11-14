(function () {
  var numero = '';
  try {
    var cfg = JSON.parse(document.getElementById('config').textContent || '{}');
    numero = String(cfg.whatsapp || '').replace(/\D/g, '');
  } catch (e) { numero = ''; }

  // Só usa o WhatsApp com um número de verdade (DDI + DDD + número).
  var valido = numero.length >= 12 && numero.length <= 13 && !/^0+$/.test(numero) && numero.indexOf('55000') !== 0;
  var instagram = 'https://www.instagram.com/soluaux/';

  document.querySelectorAll('[data-whatsapp]').forEach(function (el) {
    var assunto = el.getAttribute('data-assunto');
    var texto = assunto
      ? 'Olá! Vim pelo site da SoluAux e quero saber mais sobre ' + assunto + '.'
      : 'Olá! Vim pelo site da SoluAux e quero saber mais sobre os sistemas.';
    el.href = valido
      ? 'https://wa.me/' + numero + '?text=' + encodeURIComponent(texto)
      : instagram;
    if (!valido && el.getAttribute('data-sem-numero')) el.textContent = el.getAttribute('data-sem-numero');
    el.target = '_blank';
    el.rel = 'noopener';
  });

  var ano = document.getElementById('ano');
  if (ano) ano.textContent = String(new Date().getFullYear());
})();
