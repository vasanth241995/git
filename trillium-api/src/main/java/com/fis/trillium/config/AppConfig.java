package com.fis.trillium.config;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.fis.trillium.service.CustomizeTrilliumResponse;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;

@Configuration
public class AppConfig {

	@Bean
	public CustomizeTrilliumResponse customizeTrilliumResponse() {
		return new CustomizeTrilliumResponse();
	}
	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}

	@Bean
	public LocaleResolver localeResolver() {
		SessionLocaleResolver sessionLocaleResolver = new SessionLocaleResolver();
		sessionLocaleResolver.setDefaultLocale(Locale.US);
		return sessionLocaleResolver;

	}
	
	@Bean
	public OpenAPI openApiConfiguration() {
		return new OpenAPI()
				.info(new Info().title("Decision Solution Trillium REST API")
						.description("Decision Solution Trillium REST API")
						.license(getLicense()).termsOfService("Terms of service")
						.version("1.0.0")
						.contact(getContact()));
	}
	
	public License getLicense() {
		License license = new License();
		license.setName("FIS Proprietary");
		license.setUrl("https://www.fisglobal.com/");
		license.setExtensions(Collections.emptyMap());
		return license;
	}

	public Contact getContact() {
		Contact contact = new Contact();
		contact.setEmail("MSOL@fisglobal.com");
		contact.setName("FIS Global");
		contact.setExtensions(Collections.emptyMap());
		return contact;
	}

}
