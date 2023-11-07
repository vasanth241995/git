package com.fis.trillium.dao;

import com.fis.trillium.exception.TrilliumException;

public interface TrilliumDao {

	/**
	 *
	 * @param trilliumRequest request message in string format
	 * @param requestType     XML or JSON
	 * @return
	 * @throws TrilliumException Exception to throw.
	 */
	public String persistTrilliumRequest(String trilliumRequest, String trilliumReqString, String requestType) throws TrilliumException;

	/**
	 * @param key              uniqueId to identify
	 * @param trilliumResponse response message in string format
	 * @param responseType     XML or JSON
	 * @throws TrilliumException Excepiton to throw
	 */
	public String persistTrilliumResponse(String key, String trilliumResponse, String trilliumRespString, String responseType)
			throws TrilliumException;

}
