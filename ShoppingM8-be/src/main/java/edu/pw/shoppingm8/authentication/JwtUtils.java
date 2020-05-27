package edu.pw.shoppingm8.authentication;

import io.jsonwebtoken.Jwts;

public class JwtUtils {
    public static String getSubject(String token, byte[] key) {
        return Jwts.parser()
                .setSigningKey(key)
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }
}
