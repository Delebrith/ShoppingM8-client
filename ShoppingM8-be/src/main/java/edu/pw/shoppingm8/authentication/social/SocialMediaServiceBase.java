package edu.pw.shoppingm8.authentication.social;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.web.client.RestTemplate;

public abstract class SocialMediaServiceBase implements SocialMediaService {
    protected final RestTemplate restTemplate;

    public SocialMediaServiceBase(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    @Override
    public byte[] getPicture(SocialMediaProfileDto profile) {
        if (profile.getPictureUrl() == null)
            return null;

        return restTemplate.getForObject(profile.getPictureUrl(), byte[].class);
    }
}