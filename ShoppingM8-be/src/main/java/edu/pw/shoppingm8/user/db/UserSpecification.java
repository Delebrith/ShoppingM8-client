package edu.pw.shoppingm8.user.db;

import edu.pw.shoppingm8.user.api.dto.UserSearchDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.HashSet;
import java.util.Set;

@RequiredArgsConstructor
public class UserSpecification implements Specification<User> {
    private final UserSearchDto searchDto;

    @Override
    public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
        Set<Predicate> predicateSet = new HashSet<>();

        if (searchDto.getName() != null) {
            predicateSet.add(criteriaBuilder.like(
                    criteriaBuilder.lower(root.get("name")), "%" + searchDto.getName() + "%")
            );
        }

        return criteriaBuilder.and(predicateSet.toArray(new Predicate[0]));
    }
}
