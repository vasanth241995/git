package com.fis.trillium.dao;

import java.sql.Types;
import java.time.LocalDateTime;


import org.owasp.esapi.ESAPI;
import org.owasp.esapi.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.support.SqlLobValue;
import org.springframework.jdbc.support.lob.DefaultLobHandler;
import org.springframework.stereotype.Component;

import com.fis.trillium.exception.TrilliumException;

/**
* @author e5560057 This class is use to persist request and response database;
*/
@Component
public class TrilliumDaoImpl implements TrilliumDao {

	private static final Logger LOGGER = ESAPI.getLogger(TrilliumDaoImpl.class);

                @Autowired
                private JdbcTemplate jdbcTemplate;

                @Autowired
                private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
                public static final String REQUEST_INSERT_QUERY = "INSERT INTO TRILL_RQST_LOG (TRANS_ID,  RQST_DATA, RQST_DATA_FRMT_CD,CREAT_TS, RQST_TRILL_FRMT_DATA) VALUES (:TRANS_ID,:REQUEST, :FORMAT, :LAST_MODIFIED_DATE, :RQST_TRILL_FRMT_DATA)";
                public static final String RESPONSE_INSERT_QUERY = "INSERT INTO TRILL_RESP_LOG (TRANS_ID, RESP_DATA, RESP_DATA_FRMT_CD,CREAT_TS, RESP_TRILL_FRMT_DATA) VALUES ( :TRANS_ID,:RESPONSE, :FORMAT, :LAST_MODIFIED_DATE, :RESP_TRILL_FRMT_DATA)";
                private static final String PRIMARY_COLUMN = "TRANS_ID";

                public String getGuid() {
                                return jdbcTemplate.queryForObject("select sys_guid() from dual", String.class);
                }

                /**
                * @param messageId       uniqueId to identify
                * @param trilliumRequest request message in string format
                * @param requestType     XML or JSON
                * @throws TrilliumException Exception to throw.
                */
                @Override
                public String persistTrilliumRequest(String trilliumRequest, String trilliumReqString, String requestType) throws TrilliumException {

                                MapSqlParameterSource in = new MapSqlParameterSource();
                                String guid = getGuid();
                                in.addValue(PRIMARY_COLUMN, guid);
                                in.addValue("FORMAT", requestType);
                                in.addValue("LAST_MODIFIED_DATE", LocalDateTime.now());
                                in.addValue("REQUEST", new SqlLobValue(trilliumRequest, new DefaultLobHandler()), Types.CLOB);
                                in.addValue("RQST_TRILL_FRMT_DATA", new SqlLobValue(trilliumReqString, new DefaultLobHandler()), Types.CLOB);
                                namedParameterJdbcTemplate.update(REQUEST_INSERT_QUERY, in);
                                LOGGER.info(Logger.EVENT_SUCCESS,"persistTrilliumRequest primary key: "+ guid);
                                return guid;
                }

                @Override
                /**
                * @param messageId        uniqueId to identify
                * @param trilliumResponse response message in string format
                * @param responseType     XML or JSON
                * @throws TrilliumException Exception to throw
                */
                public String persistTrilliumResponse(String key, String trilliumResponse, String trilliumRespString, String responseType)
                                                throws TrilliumException {
                				LOGGER.info(Logger.EVENT_SUCCESS,"persistTrilliumResponse Calling");
                                MapSqlParameterSource in = new MapSqlParameterSource();
                                in.addValue(PRIMARY_COLUMN, key);
                                in.addValue("FORMAT", responseType);
                                in.addValue("LAST_MODIFIED_DATE", LocalDateTime.now());
                                in.addValue("RESPONSE", new SqlLobValue(trilliumResponse, new DefaultLobHandler()), Types.CLOB);
                                in.addValue("RESP_TRILL_FRMT_DATA", new SqlLobValue(trilliumRespString, new DefaultLobHandler()), Types.CLOB);
                                namedParameterJdbcTemplate.update(RESPONSE_INSERT_QUERY, in);
                                return key;
                }

}
