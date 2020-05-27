package edu.pw.shoppingm8.authentication.social;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.authentication.api.dto.SocialMediaLoginDto;
import edu.pw.shoppingm8.authentication.social.exception.FailedSocialMediaAuthenticationException;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Value;

@Service
public class SocialMediaServiceFacebookImpl extends SocialMediaServiceBase {
    private final String URL = "https://graph.facebook.com/v2.12/me?fields=name,email,picture&access_token={token}";
    private final HttpMethod METHOD = HttpMethod.GET;


    public SocialMediaServiceFacebookImpl(RestTemplateBuilder restTemplateBuilder) {
        super(restTemplateBuilder);
    }

    @Override
    public SocialMediaProfileDto getProfile(SocialMediaLoginDto socialMediaLoginDto) {
        ResponseEntity<FacebookProfileDto> response = restTemplate.exchange(
            URL, METHOD, null, FacebookProfileDto.class, socialMediaLoginDto.getToken());
        if (!response.getStatusCode().is2xxSuccessful())
            throw new FailedSocialMediaAuthenticationException();
        return response.getBody().asSocialMediaProfile();
    }
    
    @Value
    private static class FacebookProfileDto {
        String name;
        PictureDto picture;
        String email;

        public SocialMediaProfileDto asSocialMediaProfile() {
            return new SocialMediaProfileDto(email, name, getPictureUrl());
        }

        private String getPictureUrl() {
            if (picture == null)
                return null;
            if (picture.data == null)
                return null;
            return picture.data.url;
        }

        @Value
        @NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
        @AllArgsConstructor
        private static class PictureDto {
            PictureDataDto data;

            @Value
            @NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
            @AllArgsConstructor
            private static class PictureDataDto {
                String url;
            }
        }
    }
}