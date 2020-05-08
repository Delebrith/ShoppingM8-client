package edu.pw.shoppingm8.authentication.social;

import java.util.ArrayList;
import java.util.List;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.web.client.RestTemplate;

public abstract class SocialMediaServiceBase implements SocialMediaService {
    protected final RestTemplate restTemplate;
    protected final RestTemplate pictureRestTemplate;

    public SocialMediaServiceBase(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
        this.pictureRestTemplate = restTemplateBuilder.messageConverters(new ByteArrayHttpMessageConverter()).build();
    }

    @Override
    public byte[] getPicture(SocialMediaProfileDto profile) {
        if (profile.getPictureUrl() == null)
            return null;
        
        HttpHeaders headers = new HttpHeaders();

        List<MediaType> acceptableMediaTypes = new ArrayList<MediaType>();

        acceptableMediaTypes.add(MediaType.IMAGE_JPEG);
        acceptableMediaTypes.add(MediaType.APPLICATION_OCTET_STREAM);
        
        headers.setAccept(acceptableMediaTypes);

        HttpEntity<Void> httpEntity = new HttpEntity<Void>(headers);
        return pictureRestTemplate.exchange(profile.getPictureUrl(), HttpMethod.GET, httpEntity, byte[].class).getBody();
    }
}