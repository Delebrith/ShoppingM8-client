package edu.pw.shoppingm8.authentication.social;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.authentication.api.dto.SocialMediaLoginDto;
import edu.pw.shoppingm8.authentication.social.exception.FailedSocialMediaAuthenticationException;
import lombok.Value;

@Service
public class SocialMediaServiceGoogleImpl extends SocialMediaServiceBase {
    private final String URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    private final HttpMethod METHOD = HttpMethod.GET;

    public SocialMediaServiceGoogleImpl(RestTemplateBuilder restTemplateBuilder) {
        super(restTemplateBuilder);
    }

    @Override
    public SocialMediaProfileDto getProfile(SocialMediaLoginDto socialMediaLoginDto) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + socialMediaLoginDto.getToken());

        HttpEntity<Void> requestEntity = new HttpEntity<Void>(headers);
        ResponseEntity<GoogleProfileDto> response = restTemplate.exchange(
            URL, METHOD, requestEntity, GoogleProfileDto.class);
        if (!response.getStatusCode().is2xxSuccessful())
            throw new FailedSocialMediaAuthenticationException();
        return response.getBody().asSocialMediaProfile();
    }

    @Value
    private static class GoogleProfileDto {
        String name;
        String picture;
        String email;

        public SocialMediaProfileDto asSocialMediaProfile() {
            return new SocialMediaProfileDto(email, name, picture);
        }
    }
}