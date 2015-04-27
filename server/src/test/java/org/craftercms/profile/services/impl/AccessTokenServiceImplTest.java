package org.craftercms.profile.services.impl;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import org.craftercms.commons.http.RequestContext;
import org.craftercms.profile.api.AccessToken;
import org.craftercms.profile.api.TenantPermission;
import org.craftercms.profile.repositories.AccessTokenRepository;
import org.craftercms.profile.utils.AccessTokenUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Unit tests for {@link org.craftercms.profile.services.impl.TenantServiceImpl}.
 *
 * @author avasquez
 */
public class AccessTokenServiceImplTest {

    private static final String CURRENT_TOKEN_ID = UUID.randomUUID().toString();
    private static final String TOKEN_ID = UUID.randomUUID().toString();

    private static final String APPLICATION = "crafterstudio";
    private static final Date EXPIRES_ON = new Date(System.currentTimeMillis() + TimeUnit.DAYS.toMillis(365));

    private AccessTokenServiceImpl accessTokenService;
    @Mock
    private AccessTokenRepository accessTokenRepository;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);

        when(accessTokenRepository.findByStringId(TOKEN_ID)).thenReturn(getNormalToken());
        when(accessTokenRepository.findAll()).thenReturn(Arrays.asList(getNormalToken()));

        accessTokenService = new AccessTokenServiceImpl();
        accessTokenService.setAccessTokenRepository(accessTokenRepository);

        setCurrentRequestContext();
        setCurrentAccessToken();
    }

    @After
    public void tearDown() throws Exception {
        clearCurrentRequestContext();
    }

    @Test
    public void testCreateToken() throws Exception {
        AccessToken expected = getNormalToken();
        AccessToken actual = accessTokenService.createToken(getNormalToken());

        assertNotNull(actual);
        assertNotNull(actual.getId());
        assertEquals(expected.getApplication(), actual.getApplication());
        assertEquals(expected.isMaster(), actual.isMaster());
        assertEquals(expected.getTenantPermissions(), actual.getTenantPermissions());
        assertEquals(expected.getExpiresOn(), actual.getExpiresOn());

        verify(accessTokenRepository).save(actual);
    }

    @Test
    public void testGetToken() throws Exception {
        AccessToken expected = getNormalToken();
        AccessToken actual = accessTokenService.getToken(TOKEN_ID);

        assertNotNull(actual);
        assertEquals(expected.getId(), actual.getId());
        assertEquals(expected.getApplication(), actual.getApplication());
        assertEquals(expected.isMaster(), actual.isMaster());
        assertEquals(expected.getTenantPermissions(), actual.getTenantPermissions());
        assertEquals(expected.getExpiresOn(), actual.getExpiresOn());

        verify(accessTokenRepository).findByStringId(TOKEN_ID);
    }

    @Test
    public void testGetAll() throws Exception {
        List<AccessToken> expected = Arrays.asList(getNormalToken());
        List<AccessToken> actual = accessTokenService.getAllTokens();

        assertNotNull(actual);
        assertEquals(1, actual.size());
        assertEquals(expected.get(0), actual.get(0));

        verify(accessTokenRepository).findAll();
    }

    @Test
    public void testDeleteToken() throws Exception {
        accessTokenService.deleteToken(TOKEN_ID);

        verify(accessTokenRepository).removeByStringId(TOKEN_ID);
    }

    private AccessToken getCurrentToken() {
        AccessToken token = new AccessToken();
        token.setId(CURRENT_TOKEN_ID);
        token.setMaster(true);

        return token;
    }

    private AccessToken getNormalToken() {
        TenantPermission permission = new TenantPermission();
        permission.allowAny();

        AccessToken token = new AccessToken();
        token.setId(TOKEN_ID);
        token.setApplication(APPLICATION);
        token.setMaster(true);
        token.setTenantPermissions(Arrays.asList(permission));
        token.setExpiresOn(EXPIRES_ON);

        return token;
    }

    private void setCurrentRequestContext() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        RequestContext context = new RequestContext(request, response);

        RequestContext.setCurrent(context);
    }

    private void setCurrentAccessToken() {
        AccessTokenUtils.setCurrentToken(getCurrentToken());
    }

    private void clearCurrentRequestContext() {
        RequestContext.clear();
    }

}
