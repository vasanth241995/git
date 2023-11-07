package com.fis.trillium.controller;

import jakarta.servlet.http.HttpServletRequest;

import org.owasp.esapi.ESAPI;
import org.owasp.esapi.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.fis.trillium.entity.CleanserRequestElement;
import com.fis.trillium.entity.CleanserResponseElement;
import com.fis.trillium.exception.TrilliumException;
import com.fis.trillium.service.TrilliumService;
import com.fis.trillium.utils.ConstantUtils;

import io.swagger.v3.oas.annotations.Operation;

@RestController
public class TrilliumRestController {
	
	private static final Logger LOGGER = ESAPI.getLogger(TrilliumRestController.class);

	@Autowired
	private TrilliumService trilliumService;
	
	@Operation(description = "Get Trillium Response",tags="Trillium Rest Controller")
	@PostMapping(path = "nameAddressStandardization", produces = { MediaType.APPLICATION_XML_VALUE,
			MediaType.APPLICATION_JSON_VALUE }, consumes = { MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<CleanserResponseElement> postXMLData(
			@RequestBody CleanserRequestElement cleanserRequestElement, HttpServletRequest request)
			throws TrilliumException {

		try {
			LOGGER.info(Logger.EVENT_SUCCESS,"postXMLData ");
			LOGGER.debug(Logger.EVENT_SUCCESS,"CleanserRequestElement==> "+ cleanserRequestElement);
			LOGGER.debug(Logger.EVENT_SUCCESS,"content-type: "+request.getContentType());
			String contentType = request.getContentType();
			String type = ConstantUtils.REQUEST_TYPE_JSON;
			if (MediaType.APPLICATION_XML_VALUE.equalsIgnoreCase(contentType)) {
				type = ConstantUtils.REQUEST_TYPE_XML;
			}
			CleanserResponseElement cleanserResponseElement = trilliumService
					.getTrilliumCleanserResponse(cleanserRequestElement, type);
			return new ResponseEntity<>(cleanserResponseElement, HttpStatus.OK);

		} catch (Exception exception) {
			throw new TrilliumException(exception.getMessage(), exception);
		}
	}
	
}
