(() => {
  const config = window.HOTEL_CONFIG || {};
  const nav = document.getElementById("mainNav");
  const toggle = document.getElementById("menuToggle");
  const form = document.getElementById("bookingForm");
  const message = document.getElementById("formMessage");
  document.getElementById("year").textContent = new Date().getFullYear();

  toggle.addEventListener("click", () => {
    const open = nav.classList.toggle("open");
    toggle.setAttribute("aria-expanded", String(open));
  });
  nav.querySelectorAll("a").forEach(link => link.addEventListener("click", () => {
    nav.classList.remove("open");
    toggle.setAttribute("aria-expanded", "false");
  }));
  document.querySelectorAll("[data-service]").forEach(button => {
    button.addEventListener("click", () => {
      document.getElementById("serviceSelect").value = button.dataset.service;
      document.getElementById("reservar").scrollIntoView({behavior: "smooth"});
    });
  });

  form.addEventListener("submit", async event => {
    event.preventDefault();
    message.textContent = "";
    const data = Object.fromEntries(new FormData(form).entries());
    if (!form.elements.consent.checked) {
      message.textContent = "Necesitamos tu autorización para utilizar tus datos y responderte.";
      return;
    }
    if (!config.SUPABASE_URL || !config.SUPABASE_ANON_KEY || !window.supabase) {
      message.textContent = "La página visual ya está lista, pero el formulario todavía no está conectado a la base de datos. Configura Supabase siguiendo README.md.";
      return;
    }
    const client = window.supabase.createClient(config.SUPABASE_URL, config.SUPABASE_ANON_KEY);
    const guests = Number(data.guests);
    const payload = {
      full_name: String(data.full_name).trim(),
      email: String(data.email).trim(),
      phone: String(data.phone).trim(),
      service: data.service,
      preferred_date: data.preferred_date || null,
      guests,
      notes: String(data.notes || "").trim(),
      status: "new"
    };
    if (!Number.isInteger(guests) || guests < 1 || guests > 100) {
      message.textContent = "Revisa la cantidad de personas.";
      return;
    }
    const submit = form.querySelector('button[type="submit"]');
    submit.disabled = true;
    submit.textContent = "Enviando…";
    try {
      const { error } = await client.from("booking_requests").insert(payload);
      if (error) throw error;
      form.reset();
      message.textContent = "¡Gracias! Recibimos tu solicitud. El equipo revisará la disponibilidad y se pondrá en contacto contigo.";
    } catch (error) {
      console.error("No se pudo enviar la solicitud:", error);
      message.textContent = "No pudimos enviar la solicitud. Inténtalo de nuevo más tarde o contáctanos por teléfono.";
    } finally {
      submit.disabled = false;
      submit.textContent = "Enviar solicitud";
    }
  });
})();
